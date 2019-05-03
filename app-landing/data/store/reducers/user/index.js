import reducers from './reducers'
const localStorage = window.localStorage
const initialWallet = localStorage && localStorage.getItem('wallet')
const initialLink = localStorage && localStorage.getItem('link')
const initialPrivateKey = localStorage && localStorage.getItem('privateKey')

const initialState = {
  id: undefined,
  locale: 'en',
  wallet: initialWallet || null,
  step: 0,
  loading: false,
  errors: [],
  balance: null,
  balanceFormatted: null,
  link: initialLink || null,
  privateKey: initialPrivateKey || null,
  claimed: false,
  alert: null
}

export default (state = initialState, action = {}) => {
  const newState = { ...state }
  const { type } = action
  const actionMethod = ACTIONS[type]
  if (!actionMethod) return newState
  return actionMethod(newState, action)
}

const ACTIONS = {
  'USER.CHANGE_LOCALE': reducers.changeLocale,
  'USER.SET_WALLET': reducers.setWallet,
  'USER.SET_STEP': reducers.setStep,
  'USER.SET_LOADING': reducers.setLoading,
  'USER.SET_ERRORS': reducers.setErrors,
  'USER.SET_BALANCE': reducers.setBalance,
  'USER.SET_LINK': reducers.setLink,
  'USER.SET_PRIVATE_KEY': reducers.setPrivateKey,
  'USER.SET_CLAIMED_STATUS': reducers.setClaimedStatus,
  'USER.SET_ALERT': reducers.setAlert
}
