<template>
  <div class="contact">
    <list :list='lcontacts' :disable="disableList" :title="IntlString('APP_CONTACT_TITLE')" @back="back" @select='onSelect' @option='onOption'></list>
        <button
          class="special_menu"
          @click="openApp({routeName: 'menu'})"
          >
        </button>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import { generateColorForStr } from '@/Utils'
import List from './../List.vue'
import Modal from '@/components/Modal/index.js'

export default {
  components: {
    List
  },
  data () {
    return {
      disableList: false
    }
  },
  computed: {
    ...mapGetters(['IntlString', 'contacts', 'useMouse', 'AppsHome']),
    lcontacts () {
      let addContact = {display: this.IntlString('APP_CONTACT_NEW'), letter: '+', num: '', id: -1}
      return [addContact, ...this.contacts.map(e => {
        e.backgroundColor = e.backgroundColor || generateColorForStr(e.number + '')
        return e
      })]
    }
  },
  methods: {
    onSelect (contact) {
      if (contact.id === -1) {
        this.$router.push({ name: 'contacts.view', params: { id: contact.id } })
      } else {
        this.$router.push({ name: 'messages.view', params: { number: contact.number, display: contact.display } })
      }
    },
    openApp (app) {
      this.$router.push({ name: app.routeName })
    },
    onOption (contact) {
      if (contact.id === -1 || contact.id === undefined) return
      this.disableList = true
      Modal.CreateModal({
        choix: [
          {id: 1, title: this.IntlString('APP_CONTACT_EDIT'), icons: 'fas fa-address-book', color: 'orange'},
          {id: 3, title: 'Annuler', icons: 'fa-undo'}
        ]
      }).then(rep => {
        if (rep.id === 1) {
          this.$router.push({path: 'contact/' + contact.id})
        } else if (rep.id === 2) {
          this.$router.push({ name: 'contacts.view', params: { number: contact.number, display: contact.display } })
        }
        this.disableList = false
      })
    },
    back () {
      if (this.disableList === true) return
      this.$router.push({ name: 'home' })
    }
  },
  created () {
    if (!this.useMouse) {
      this.$bus.$on('keyUpBackspace', this.back)
    }
  },

  beforeDestroy () {
    this.$bus.$off('keyUpBackspace', this.back)
  }
}
</script>

<style scoped>
.contact{
  position: relative;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
}

.special_menu {
  height: 9px;
  width: 200px;
  background-color: white;
  position: absolute;
  bottom: 10px;
  border-radius: 25px;
  left: 0;
  right: 0;
  margin: auto;
  padding: 0;
  transition: 0.2s;
}

.special_menu:hover {
  transition: 0.2s;
  left: 50px;
}
</style>
