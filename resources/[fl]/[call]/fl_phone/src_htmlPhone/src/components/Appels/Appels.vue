<template>
   <div class="phone_app">
    <PhoneTitle :title="IntlString('APP_PHONE_TITLE')" v-on:back="onBackspace" />
    <div class="content">
      <component :is="subMenu[currentMenuIndex].Comp" />
    </div>
    <div class="subMenu">
      <div
        class="subMenu-elem"
        :style="getColorItem(i)"
        v-for="(Comp, i) of subMenu"
        :key="i"
        @click="swapMenu(i)"
      >
        <i class="subMenu-icon fa" :class="['fa-' + Comp.icon]" @click.stop="swapMenu(i)"></i>
        <span class="subMenu-name" @click.stop="swapMenu(i)">{{Comp.name}}</span>
      </div>
    </div>
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
import { mapGetters } from 'vuex'

import PhoneTitle from './../PhoneTitle'
import AppelsFavoris from './AppelsFavoris'
import AppelsContacts from './AppelsContacts'
import AppelsRecents from './AppelsRecents'
import AppelsNumber from './AppelsNumber'

export default {
  components: {
    PhoneTitle
  },
  data () {
    return {
      currentMenuIndex: 1
    }
  },
  computed: {
    ...mapGetters(['IntlString', 'useMouse', 'themeColor', 'AppsHome']),
    subMenu () {
      return [{
        Comp: AppelsRecents,
        name: this.IntlString('APP_PHONE_MENU_RECENTS'),
        icon: 'clock'
      }, {
        Comp: AppelsFavoris,
        name: this.IntlString('APP_PHONE_MENU_FAVORITES'),
        icon: 'star'
      }, {
        Comp: AppelsNumber,
        name: this.IntlString('Clavier'),
        icon: 'keyboard'
      }, {
        Comp: AppelsContacts,
        name: this.IntlString('APP_PHONE_MENU_CONTACTS'),
        icon: 'user-circle'
      }]
    }
  },
  methods: {
    getColorItem (index) {
      if (this.currentMenuIndex === index) {
        return {
          color: this.themeColor
        }
      }
      return {}
    },
    openApp (app) {
      this.$router.push({ name: app.routeName })
    },
    swapMenu (index) {
      this.currentMenuIndex = index
    },
    onLeft () {
      this.currentMenuIndex = Math.max(this.currentMenuIndex - 1, 0)
    },
    onRight () {
      this.currentMenuIndex = Math.min(this.currentMenuIndex + 1, this.subMenu.length - 1)
    },
    onBackspace: function () {
      if (this.ignoreControls === true) return
      if (this.currentMenuIndex !== 2) {
        this.$router.push({ name: 'home' })
      }
    }
  },

  created () {
    if (!this.useMouse) {
      this.$bus.$on('keyUpBackspace', this.onBackspace)
      this.$bus.$on('keyUpArrowLeft', this.onLeft)
      this.$bus.$on('keyUpArrowRight', this.onRight)
    }
  },
  beforeDestroy () {
    this.$bus.$off('keyUpBackspace', this.onBackspace)
    this.$bus.$off('keyUpArrowLeft', this.onLeft)
    this.$bus.$off('keyUpArrowRight', this.onRight)
  }
}
</script>

<style scoped>
.content {
  height: 630px;
}
.screen{
  position: relative;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
}
.title{
  padding-left: 16px;
  height: 34px;
  line-height: 34px;
  font-weight: 700;
  color: white;
  background-color: #2c3e50;
}
.subMenu{
  position: absolute;
  bottom: 40px;
  left: 0; right: 0;
  border-top: 1px solid rgba(0,0,0,0.24);
  display: flex;
  height: 56px;
}
.subMenu-elem {
  height: 100%;
  width: 100%;
  text-align: center;
  line-height: 56px;
  height: 56px;
  display: flex;
  color: #959595;
  flex-direction: column;
}
.subMenu-elem-select, .subMenu-elem:hover {
  color: #0079d3;
}
.subMenu-icon{
  margin-top: 6px;
  font-size: 22px;
  line-height: 22px;
  height: 22px;
}
.subMenu-name{
  display: block;
  font-size: 14px;
  height: 14px;
  line-height: 14px;
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
