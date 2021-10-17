import PhoneAPI from './../../PhoneAPI'

const state = {
  contacts: [],
  defaultContacts: []
}

const getters = {
  contacts: ({ contacts, defaultContacts }) => [...contacts, ...defaultContacts]
}

const actions = {
  updateContact (context, {id, display, number}) {
    PhoneAPI.updateContact(id, display, number)
  },
  addContact (context, {display, number}) {
    PhoneAPI.addContact(display, number)
  },
  deleteContact (context, {id}) {
    PhoneAPI.deleteContact(id)
  },
  resetContact ({ commit }) {
    commit('SET_CONTACTS', [])
  }
}

const mutations = {
  SET_CONTACTS (state, contacts) {
    state.contacts = contacts.sort((a, b) => a.display.localeCompare(b.display))
  },
  SET_DEFAULT_CONTACTS (state, contacts) {
    state.defaultContacts = contacts
  }
}

export default {
  state,
  getters,
  actions,
  mutations
}

if (process.env.NODE_ENV !== 'production') {
  // eslint-disable-next-line
  state.contacts = [{
    id: 2,
    number: '336-4557',
    display: 'John doe'
  },
  {
    id: 4,
    number: '336-4553',
    display: 'Nop user'
  },
  {
    id: 5,
    number: '336-4553',
    display: ''
  },
  {
    id: 6,
    number: '',
    display: 'b'
  },
  {
    id: 7,
    number: undefined,
    display: 'b2'
  },
  {
    id: 8,
    number: 'a',
    display: undefined
  }]
}
