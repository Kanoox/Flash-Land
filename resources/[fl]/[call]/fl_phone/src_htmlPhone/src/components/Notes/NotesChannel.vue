<template>
  <div class="phone_app">
    <PhoneTitle :title="IntlString('APP_NOTES')" color="white" @back="onBack" />
    <div style="backgroundColor: rgb(22,22,22);" class="elements" @contextmenu.prevent="addChannelOption">
        <div
          >
            <div v-for='(elem, key) in notesChannels'
          v-bind:key="elem.channel"
          v-bind:class="{ select: key === currentSelect}" class="elem-title">
              <h3 style="margin-left: 10px; margin-top: 10px; margin-right: 10px; font-size: 25px; font-weight: bold; color: white;"> {{elem.channel}}</h3>
            </div>
        </div>
        <button
          class="special_menu"
          @click="openApp({routeName: 'menu'})"
          >
        </button>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import Modal from '@/components/Modal/index.js'
import PhoneTitle from './../PhoneTitle'

export default {
  components: { PhoneTitle },
  data: function () {
    return {
      currentSelect: 0,
      ignoreControls: false
    }
  },
  watch: {
    list: function () {
      this.currentSelect = 0
    }
  },
  computed: {
    ...mapGetters(['IntlString', 'useMouse', 'notesChannels', 'Apps', 'AppsHome'])
  },
  methods: {
    ...mapActions(['notesAddChannel', 'notesRemoveChannel']),
    scrollIntoViewIfNeeded () {
      this.$nextTick(() => {
        const $select = this.$el.querySelector('.select')
        if ($select !== null) {
          $select.scrollIntoViewIfNeeded()
        }
      })
    },
    onUp () {
      if (this.ignoreControls === true) return
      this.currentSelect = this.currentSelect === 0 ? 0 : this.currentSelect - 1
      this.scrollIntoViewIfNeeded()
    },
    onDown () {
      if (this.ignoreControls === true) return
      this.currentSelect = this.currentSelect === this.notesChannels.length - 1 ? this.currentSelect : this.currentSelect + 1
      this.scrollIntoViewIfNeeded()
    },
    async onRight () {
      if (this.ignoreControls === true) return
      this.ignoreControls = true
      let choix = [
        {id: 1, title: this.IntlString('Nouvelle note'), icons: 'fa-plus', color: 'dodgerblue'},
        {id: 2, title: this.IntlString('Supprimer la note'), icons: 'fa-minus', color: 'tomato'},
        {id: 3, title: this.IntlString('Annuler'), icons: 'fa-undo'}
      ]
      if (this.notesChannels.length === 0) {
        choix.splice(1, 1)
      }
      const rep = await Modal.CreateModal({ choix })
      this.ignoreControls = false
      switch (rep.id) {
        case 1:
          this.addChannelOption()
          break
        case 2:
          this.removeChannelOption()
          break
        case 3 :
      }
    },
    async onEnter () {
      if (this.ignoreControls === true) return
      if (this.notesChannels.length === 0) {
        this.ignoreControls = true
        let choix = [
          {id: 1, title: this.IntlString('Ajouter une note'), icons: 'fa-plus', color: 'green'},
          {id: 3, title: this.IntlString('Annuler'), icons: 'fa-undo'}
        ]
        const rep = await Modal.CreateModal({ choix })
        this.ignoreControls = false
        if (rep.id === 1) {
          this.addChannelOption()
        }
      } else {
      }
    },
    showChannel (channel) {
      this.$router.push({ name: 'notes.channel.show', params: { channel } })
    },
    onBack () {
      if (this.ignoreControls === true) return
      this.$router.push({ name: 'home' })
    },
    openApp (app) {
      this.$router.push({ name: app.routeName })
    },
    async addChannelOption () {
      try {
        const rep = await Modal.CreateTextModal({limit: 280, title: this.IntlString('Ajouter une note')})
        let channel = (rep || {}).text || ' '
        channel
        if (channel.length > 0) {
          this.currentSelect = 0
          this.notesAddChannel({ channel })
        }
      } catch (e) {}
    },
    async removeChannelOption () {
      const channel = this.notesChannels[this.currentSelect].channel
      this.currentSelect = 0
      this.notesRemoveChannel({ channel })
    }
  },
  created () {
    if (!this.useMouse) {
      this.$bus.$on('keyUpArrowDown', this.onDown)
      this.$bus.$on('keyUpArrowUp', this.onUp)
      this.$bus.$on('keyUpArrowRight', this.onRight)
      this.$bus.$on('keyUpEnter', this.onEnter)
      this.$bus.$on('keyUpBackspace', this.onBack)
    } else {
      this.currentSelect = -1
    }
  },
  beforeDestroy () {
    this.$bus.$off('keyUpArrowDown', this.onDown)
    this.$bus.$off('keyUpArrowUp', this.onUp)
    this.$bus.$off('keyUpArrowRight', this.onRight)
    this.$bus.$off('keyUpEnter', this.onEnter)
    this.$bus.$off('keyUpBackspace', this.onBack)
  }
}
</script>

<style scoped>
.list{
  height: 100%;
}
.title{
  padding-top: 22px;
  padding-left: 16px;
  height: 54px;
  line-height: 34px;
  font-weight: 700;
  color: white;
}

.elements{
  height: calc(100% - 54px);
  overflow-y: auto;
  background-color: #20201d;
  color: #34302f
}
.element{
  margin-top: 50px;
  height: 42px;
  line-height: 42px;
  display: flex;
  align-items: center;
  position: relative;
}

.elem-title{
  margin-left: 6px;
  width: 300px;
  font-size: 20px;
  transition: .15s;
  font-weight: 200;
  color: #34302f;
  margin-left: 13px;
  border-radius: 13px;

}
.elem-title .diese {
  color: #34302f;
  font-size: 22px;
  font-weight: 700;
  line-height: 40px;
}

.elem-title.select, .elem-title:hover{
   background-color:rgba(112, 108, 108, 0.1);
   color: #34302f;

}
.element.select .elem-title, .element:hover .elem-title {
   margin-left: 12px;
}
.element.select .elem-title .diese, .element:hover .elem-title .diese {
   color:#f8d344;
}
 .elements::-webkit-scrollbar-track
    {
        box-shadow: inset 0 0 6px rgba(0,0,0,0.3);
        background-color: #F5F5F5;
    }
  .elements::-webkit-scrollbar
    {
        width: 3px;
        background-color: transparent;
    }
  .elements::-webkit-scrollbar-thumb
    {
        background-color: white;
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
