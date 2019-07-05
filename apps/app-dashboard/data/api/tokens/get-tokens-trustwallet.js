import fetch from '../fetch'
import { prepareGetParams } from 'data/api/helpers'
import configs from 'config-dashboard'

export default ({ wallet }) => {
  const getParams = prepareGetParams({
    address: wallet
  })
  return fetch(`${configs.trustWallet}/tokens${getParams}`)
}
