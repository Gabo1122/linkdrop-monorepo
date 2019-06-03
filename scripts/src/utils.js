import LinkdropSDK from '../../sdk/src/index'
const path = require('path')
const configPath = path.resolve(__dirname, '../../config/scripts.config.json')
const config = require(configPath)
let { masterCopy, factory } = config

export const getMasterCopyAddress = () => {
  if (masterCopy == null || masterCopy === '') {
    throw 'Please provide linkdrop master copy address'
  }
  return masterCopy
}

export const getFactoryAddress = () => {
  if (factory == null || factory === '') {
    throw 'Please provide factory contract address'
  }
  return factory
}

export const getInitcode = () => {
  return '0x6352c7420d6000526103ff60206004601c335afa6040516060f3'
}

export const getBytecode = () => {
  const masterCopyAddress = getMasterCopyAddress()
  const bytecode = LinkdropSDK.computeBytecode(masterCopyAddress)
  return bytecode
}
