pragma solidity ^0.5.12;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "../interfaces/ILinkdropCommon.sol";

contract LinkdropCommon is ILinkdropCommon, ReentrancyGuard {

    using SafeMath for uint;
    using Address for address payable;

    // Owner address
    address public owner;

    // Sender address
    address payable public sender;

    // Mastercopy version
    uint public version;

    // Chain id
    uint public chainId;

    // Indicates whether an address corresponds to signing key
    mapping (address => bool) public isSigner;

    // Indicates where the link is claimed to
    mapping (address => address) public claimedTo;

    // Indicates whether the link is canceled or not
    mapping (address => bool) internal _canceled;

    // Indicates whether the initializer function has been called or not
    bool public initialized;

    // Indicates whether the contract is paused or not
    bool internal _paused;

    /**
    * @dev Function called only once to set owner, sender, contract version and chain id
    * @param _owner Owner address
    * @param _sender Sender address
    * @param _version Contract version
    * @param _chainId Network id
    */
    function initialize
    (
        address _owner,
        address payable _sender,
        uint _version,
        uint _chainId
    )
    public
    returns (bool)
    {
        require(!initialized, "LINKDROP_PROXY_CONTRACT_ALREADY_INITIALIZED");
        owner = _owner;
        sender = _sender;
        isSigner[sender] = true;
        version = _version;
        chainId = _chainId;
        initialized = true;
        return true;
    }

    modifier onlySender() {
        require(msg.sender == sender, "ONLY_SENDER");
        _;
    }

    modifier onlySenderOrOwner() {
        require (msg.sender == sender || msg.sender == owner, "ONLY_SENDER_OR_OWNER");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "ONLY_OWNER");
        _;
    }

    modifier whenNotPaused() {
        require(!paused(), "LINKDROP_PROXY_CONTRACT_PAUSED");
        _;
    }

    /**
    * @dev Indicates whether a link is claimed or not
    * @param _linkId Address corresponding to link key
    * @return True if claimed
    */
    function isClaimedLink(address _linkId) public view returns (bool) {
        return claimedTo[_linkId] != address(0);
    }

    /**
    * @dev Indicates whether a link is canceled or not
    * @param _linkId Address corresponding to link key
    * @return True if canceled
    */
    function isCanceledLink(address _linkId) public view returns (bool) {
        return _canceled[_linkId];
    }

    /**
    * @dev Indicates whether a contract is paused or not
    * @return True if paused
    */
    function paused() public view returns (bool) {
        return _paused;
    }

    /**
    * @dev Function to cancel a link, can only be called by sender
    * @param _linkId Address corresponding to link key
    * @return True if success
    */
    function cancel(address _linkId) external onlySender returns (bool) {
        require(!isClaimedLink(_linkId), "LINK_CLAIMED");
        _canceled[_linkId] = true;
        emit Canceled(_linkId);
        return true;
    }

    /**
    * @dev Function to withdraw all remaining native tokens to sender, can only be called by sender
    * @return True if success
    */
    function withdraw() external onlySender nonReentrant returns (bool) {
        sender.sendValue(address(this).balance);
        return true;
    }

    /**
    * @dev Function to pause contract, can only be called by sender
    * @return True if success
    */
    function pause() external onlySender whenNotPaused returns (bool) {
        _paused = true;
        emit Paused();
        return true;
    }

    /**
    * @dev Function to unpause contract, can only be called by sender
    * @return True if success
    */
    function unpause() external onlySender returns (bool) {
        require(paused(), "LINKDROP_CONTRACT_ALREADY_UNPAUSED");
        _paused = false;
        emit Unpaused();
        return true;
    }

    /**
    * @dev Function to add new signing key, can only be called by sender or owner
    * @param _signer Address corresponding to signing key
    * @return True if success
    */
    function addSigner(address _signer) external payable onlySenderOrOwner returns (bool) {
        require(_signer != address(0), "INVALID_SIGNER_ADDRESS");
        isSigner[_signer] = true;
        return true;
    }

    /**
    * @dev Function to remove signing key, can only be called by sender
    * @param _signer Address corresponding to signing key
    * @return True if success
    */
    function removeSigner(address _signer) external onlySender returns (bool) {
        require(_signer != address(0), "INVALID_SIGNER_ADDRESS");
        isSigner[_signer] = false;
        return true;
    }

    /**
    * @dev Function to destroy this contract, can only be called by owner or sender
    * Withdraws all the remaining native tokens to sender
    */
    function destroy() external onlySenderOrOwner {
        selfdestruct(sender);
    }

    /**
    * @dev Function for other contracts to be able to fetch the mastercopy version
    * @return Master copy version
    */
    function getMasterCopyVersion() external view returns (uint) {
        return version;
    }

    /**
    * @dev Fallback function to accept native tokens
    */
    function () external payable {}

}