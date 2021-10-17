const state = {
  bankAmount: '?',
  bankSocietyAmount: '?'
}

const getters = {
  bankAmount: ({ bankAmount }) => bankAmount,
  bankSocietyAmount: ({ bankSocietyAmount }) => bankSocietyAmount
}

const actions = {
}

const mutations = {
  SET_BANK_AMOUNT (state, bankAmount) {
    state.bankAmount = bankAmount
  },
  SET_SOCIETY_AMOUNT (state, bankSocietyAmount) {
    state.bankSocietyAmount = bankSocietyAmount
  }
}

export default {
  state,
  getters,
  actions,
  mutations
}

