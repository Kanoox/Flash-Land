<template>
  <div class="contact">
    <list :list='lcontacts' :title="IntlString('APP_MESSAGE_CONTACT_TITLE')" v-on:select="onSelect" @back="back"></list>
            <button
          class="special_menu"
          @click="openApp({routeName: 'messages'})"
          >
        </button>
  </div>
</template>

<script>
import List from './../List.vue'
import { mapGetters } from 'vuex'
import Modal from '@/components/Modal/index.js'

export default {
  components: {
    List
  },
  data () {
    return {
    }
  },
  computed: {
    ...mapGetters(['IntlString', 'contacts', 'useMouse', 'AppsHome']),
    lcontacts () {
      let addContact = {
        display: this.IntlString('APP_MESSAGE_CONTRACT_ENTER_NUMBER'),
        letter: '+',
        backgroundColor: 'orange',
        num: -1
      }
      return [addContact, ...this.contacts]
    }
  },
  methods: {
    onSelect (contact) {
      if (contact.num === -1) {
        Modal.CreateTextModal({
          title: this.IntlString('APP_PHONE_ENTER_NUMBER'),
          limit: 10
        }).then(data => {
          let message = data.text.trim()
          if (message !== '') {
            this.$router.push({
              name: 'messages.view',
              params: {
                number: message,
                display: message
              }
            })
          }
        })
      } else {
        this.$router.push({name: 'messages.view', params: contact})
      }
    },
    openApp (app) {
      this.$router.push({ name: app.routeName })
    },
    back () {
      history.back()
    }
  },
  created () {
    this.$bus.$on('keyUpBackspace', this.back)
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
