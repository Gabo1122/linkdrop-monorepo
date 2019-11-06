pragma solidity ^0.5.6;
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract LinkdropFactoryStorage is Ownable {

    // Current version of mastercopy contract
    uint public masterCopyVersion;

    // Contract bytecode to be installed when deploying proxy
    bytes internal _bytecode;

    // Bootstrap initcode to fetch the actual contract bytecode. Used to generate repeatable contract addresses
    bytes internal _initcode;

    // Network id
    uint public chainId;

    mapping (address => bool) internal _isDeployed;

    // Events
    event Deployed(address indexed sender, uint campaignId, address payable proxy, bytes32 salt);
    event Destroyed(address payable sender, address payable proxy);
    event SetMasterCopy(address masterCopy, uint version);

}