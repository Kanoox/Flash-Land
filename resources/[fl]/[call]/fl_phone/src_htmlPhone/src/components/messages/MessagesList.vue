<template>
  <div class="screen">
    <list :list='messagesData' :disable="disableList" :title="IntlString('APP_MESSAGE_TITLE')" @back="back" @select="onSelect" @option='onOption'></list>
    <div class='home_buttons'>
      <div class="btn_menu_ctn">
        <button
          class="btn_menu special_menu"
          :class="{ select: AppsHome.length === currentSelect}"
          @click="openApp({routeName: 'home'})"
          >
        </button>
      </div>
    </div>
  </div>

</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import { generateColorForStr } from '@/Utils'
import Modal from '@/components/Modal/index.js'
import List from '@/components/List'

export default {
  components: {
    List
  },
  data () {
    return {
      disableList: false
    }
  },
  methods: {
    ...mapActions(['deleteMessagesNumber', 'deleteAllMessages', 'startCall']),
    onSelect: function (data) {
      if (data.id === -1) {
        this.$router.push({name: 'messages.selectcontact'})
      } else {
        this.$router.push({name: 'messages.view', params: data})
      }
    },
    openApp (app) {
      this.$router.push({ name: app.routeName })
    },
    onOption: function (data) {
      if (data.number === undefined) return
      this.disableList = true
      const c = this.contacts.find(e => e.number === data.number)

      Modal.CreateModal({
        choix: [
          {id: 7, title: c === undefined ? this.IntlString('APP_CONTACT_NEW') : this.IntlString('APP_CONTACT_EDIT'), icons: 'fa-address-book'},
          {id: 4, title: this.IntlString('APP_PHONE_CALL'), icons: 'fa-phone'},
          {id: 5, title: this.IntlString('APP_PHONE_CALL_ANONYMOUS'), icons: 'fa-mask'},
          {id: 6, title: this.IntlString('APP_MESSAGE_NEW_MESSAGE'), icons: 'fa-sms'},
          {id: 1, title: this.IntlString('APP_MESSAGE_ERASE_CONVERSATION'), icons: 'fa-trash', color: 'orange'},
          {id: 2, title: this.IntlString('APP_MESSAGE_ERASE_ALL_CONVERSATIONS'), icons: 'fa-trash', color: 'red'},
          {id: 3, title: this.IntlString('CANCEL'), icons: 'fa-undo'}
        ]
      }).then(rep => {
        if (rep.id === 1) {
          this.deleteMessagesNumber({num: data.number})
        } else if (rep.id === 2) {
          this.deleteAllMessages()
        } else if (rep.id === 4) {
          this.startCall({ numero: data.number })
        } else if (rep.id === 5) {
          this.startCall({ numero: '#' + data.number })
        } else if (rep.id === 6) {
          this.$router.push({name: 'messages.selectcontact', params: data})
        } else if (rep.id === 7) {
          if (c === undefined) {
            this.$router.push({ name: 'contacts.view', params: { id: -1, number: data.number } })
          } else {
            this.$router.push({ path: 'contact/' + c.id })
          }
        }
        this.disableList = false
      })
    },
    back: function () {
      if (this.disableList === true) return
      this.$router.push({ name: 'home' })
    }
  },
  computed: {
    ...mapGetters(['IntlString', 'useMouse', 'contacts', 'messages', 'AppsHome']),
    messagesData: function () {
      let messages = this.messages
      let contacts = this.contacts
      let messGroup = messages.reduce((rv, x) => {
        if (rv[x['transmitter']] === undefined) {
          const data = {
            noRead: 0,
            lastMessage: 0,
            display: x.transmitter
          }
          let contact = contacts.find(e => e.number === x.transmitter)
          data.unknowContact = contact === undefined
          if (contact !== undefined) {
            data.display = contact.display
            data.backgroundColor = contact.backgroundColor || generateColorForStr(x.transmitter)
            data.letter = contact.letter
            data.icon = contact.icon
          } else {
            data.backgroundColor = generateColorForStr(x.transmitter)
          }
          rv[x['transmitter']] = data
        }
        if (x.isRead === 0) {
          rv[x['transmitter']].noRead += 1
        }
        if (x.time >= rv[x['transmitter']].lastMessage) {
          rv[x['transmitter']].lastMessage = x.time
          rv[x['transmitter']].keyDesc = x.message
        }
        return rv
      }, {})
      let mess = []
      Object.keys(messGroup).forEach(key => {
        mess.push({
          display: messGroup[key].display,
          puce: messGroup[key].noRead,
          number: key,
          lastMessage: messGroup[key].lastMessage,
          keyDesc: messGroup[key].keyDesc,
          backgroundColor: messGroup[key].backgroundColor,
          icon: messGroup[key].icon,
          letter: messGroup[key].letter,
          unknowContact: messGroup[key].unknowContact
        })
      })
      mess.sort((a, b) => b.lastMessage - a.lastMessage)
      return [this.newMessageOption, ...mess]
    },
    newMessageOption () {
      return {
        backgroundColor: '#C0C0C0',
        display: this.IntlString('APP_MESSAGE_NEW_MESSAGE'),
        letter: '+',
        id: -1
      }
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
.screen{
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
