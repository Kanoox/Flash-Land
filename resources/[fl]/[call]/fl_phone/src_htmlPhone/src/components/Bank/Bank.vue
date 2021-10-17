<template>
    <div class="phone_app">
    <PhoneTitle :title="title" :showInfoBare="showInfoBare" v-if="showHeader" @back="quit"/>
  <div class="screen" @click="onBackspace">
    <div class='elements'>
      <img class="logo_maze" src="/html/static/img/app_bank/logo_mazebank.jpg">
      <div class="hr"></div>
      <div class='element'>
        <div class="element-content">
          <span>Personnel : {{ bankAmountFormat }}</span> <br>
          <span>Entreprise : {{ bankSocietyAmountFormat }}</span>
        </div>
      </div>
    </div>
        <button
          class="special_menu"
          @click="openApp({routeName: 'menu'})"
          >
        </button>
  </div>
</div>
</PhoneTitle>
</template>

<script>
import PhoneTitle from './../PhoneTitle'
import InfoBare from './../InfoBare'
import { mapGetters } from 'vuex'

export default {
  data () {
    return {
    }
  },
  components: {
    PhoneTitle, InfoBare
  },
  props: {
    title: {
      type: String,
      default: 'Banque'
    },
    showHeader: {
      type: Boolean,
      default: true
    },
    showInfoBare: {
      type: Boolean,
      default: true
    },
    list: {
      type: Array,
      required: true
    },
    color: {
      type: String,
      default: '#FFFFFF'
    },
    backgroundColor: {
      type: String,
      default: '#4CAF50'
    },
    keyDispay: {
      type: String,
      default: 'display'
    },
    disable: {
      type: Boolean,
      default: false
    },
    titleBackgroundColor: {
      type: String,
      default: '#FFFFFF'
    }
  },
  computed: {
    ...mapGetters(['bankAmount', 'bankSocietyAmount', 'AppsHome']),
    bankAmountFormat () {
      return this.bankAmount
    },
    bankSocietyAmountFormat () {
      return this.bankSocietyAmount
    }
  },
  methods: {
    onBackspace () {
      this.$router.push({ name: 'menu' })
    },
    openApp (app) {
      this.$router.push({ name: app.routeName })
    }
  },
  created () {
    this.$bus.$on('keyUpBackspace', this.onBackspace)
  },
  beforeDestroy () {
    this.$bus.$off('keyUpBackspace', this.onBackspace)
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
  padding: 18px;
  background-color: rgb(22,22,22);
}
.title{
  padding-left: 16px;
  height: 34px;
  line-height: 34px;
  font-weight: 700;
  color: white;
  background-color: rgb(76, 175, 80);
}
.elements{
  display: block;
  position: relative;
  width: 100%;
  flex-direction: column;
  height: 100%;
  justify-content: center;
}
.hr{
    width: auto;
    height: 4px;
    margin-top: 10px;
    background-color: #EB202D;
}
.logo_maze {
  display: block;
  margin-left: auto;
  margin-right: auto;
  width: 50%;
}
.element-content{
  margin-top: 24px;
  display: block;
  height: 40px;
  width: 100%;
  text-align: center;
  font-weight: 700;
  font-size: 24px;
  color: #eee;
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
