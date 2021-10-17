<template>
  <div class="home" v-bind:style="{background: 'url(' + backgroundURL +')'}">
    <span class="time">
      <img src="/html/static/img/icons_app/lockopen.png" style=" width: 60px; ">
      <current-time></current-time>
      <br />
    </span>
    {{config.config}}
    <InfoBare />
    <span class="warningMess" v-if="messages.length >= warningMessageCount">
      <div class="warningMess_icon"><i class="fa fa-warning"></i></div>
      <span class="warningMess_content">
        <span class="warningMess_title">{{ IntlString('PHONE_WARNING_MESSAGE') }}</span><br>
        <span class="warningMess_mess">{{messages.length}} / {{warningMessageCount}} {{IntlString('PHONE_WARNING_MESSAGE_MESS')}}</span>
      </span>
    </span>
    <div class='home_buttons'>
      <button
          v-for="(but, key) of AppsHome"
          v-bind:key="but.name"
          v-bind:class="{ select: key === currentSelect}"
          v-bind:name="but.intlName.toLowerCase()"
          v-bind:style="{backgroundImage: 'url(' + but.icons +')'}"
          @click="openApp(but)"
         >
          <span class="puce" v-if="but.puce !== undefined && but.puce !== 0">{{but.puce}}</span>
      </button>
      <div class="btn_menu_ctn">
        <button
          class="btn_menu special_menu"
          :class="{ select: AppsHome.length === currentSelect}"
          @click="openApp({routeName: 'menu'})"
          >
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import CurrentTime from './CurrentTime'
import InfoBare from './InfoBare'

export default {
  components: {
    InfoBare,
    CurrentTime
  },
  data () {
    return {
      currentSelect: 0
    }
  },
  computed: {
    ...mapGetters(['IntlString', 'useMouse', 'nbMessagesUnread', 'backgroundURL', 'messages', 'AppsHome', 'warningMessageCount', 'config'])
  },
  methods: {
    ...mapActions(['closePhone', 'setMessages']),
    onLeft () {
      this.currentSelect = (this.currentSelect + this.AppsHome.length) % (this.AppsHome.length + 1)
    },
    onRight () {
      this.currentSelect = (this.currentSelect + 1) % (this.AppsHome.length + 1)
    },
    onUp () {
      this.currentSelect = Math.max(this.currentSelect - 4, 0)
    },
    onDown () {
      this.currentSelect = Math.min(this.currentSelect + 4, this.AppsHome.length)
    },
    openApp (app) {
      this.$router.push({ name: app.routeName })
    },
    onEnter () {
      this.openApp(this.AppsHome[this.currentSelect] || {routeName: 'menu'})
    },
    onBack () {
      this.closePhone()
    }
  },
  created () {
    if (!this.useMouse) {
      this.$bus.$on('keyUpArrowLeft', this.onLeft)
      this.$bus.$on('keyUpArrowRight', this.onRight)
      this.$bus.$on('keyUpArrowDown', this.onDown)
      this.$bus.$on('keyUpArrowUp', this.onUp)
      this.$bus.$on('keyUpEnter', this.onEnter)
    } else {
      this.currentSelect = -1
    }
    this.$bus.$on('keyUpBackspace', this.onBack)
  },
  beforeDestroy () {
    this.$bus.$off('keyUpArrowLeft', this.onLeft)
    this.$bus.$off('keyUpArrowRight', this.onRight)
    this.$bus.$off('keyUpArrowDown', this.onDown)
    this.$bus.$off('keyUpArrowUp', this.onUp)
    this.$bus.$off('keyUpEnter', this.onEnter)
    this.$bus.$off('keyUpBackspace', this.onBack)
  }
}
</script>

<style scoped="true">
.home{
  background-size: cover !important;
  background-position: center !important;
  position: relative;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  display: flex;
  align-content: center;
  justify-content: center;
  color: gray;
}
.warningMess{
  background-color: white;
  position: absolute;
  left: 12px;
  right: 12px;
  top: 34px;
  min-height: 64px;
  display: flex;
  padding: 12px;
  border-radius: 4px;
  box-shadow: 0 2px 2px 0 rgba(0,0,0,.14), 0 3px 1px -2px rgba(0,0,0,.2), 0 1px 5px 0 rgba(0,0,0,.12);
}
.warningMess .warningMess_icon{
  display: flex;
  width: 16%;
  align-items: center;
  justify-content: center;
  font-size: 28px;
  height: 42px;
  width: 42px;
  border-radius: 50%;
}
.warningMess .warningMess_icon .fa {
  text-align: center;
  color: #F94B42;
}
.warningMess .warningMess_content{
  padding-left: 12px;
}
.warningMess_title {
  font-size: 20px;
}
.warningMess_mess {
  font-size: 16px;
}

.home_buttons{
  display: -ms-flexbox;
  display: flex;
  padding: 0px 15px;
  padding-top: 0px;
  bottom: 47px;
  position: absolute;
  -ms-flex-align: end;
  align-items: flex-end;
  -ms-flex-flow: row;
  flex-flow: row;
  flex-wrap: nowrap;
  -ms-flex-wrap: wrap;
  flex-wrap: wrap;
  margin-bottom: 0px;
  -ms-flex-pack: justify;
  justify-content: space-between;
  transition: all 0.5s ease-in-out;
  background: rgba(255,255,255,0.2);
  padding-top: 10px;
  height: 91px;
  left: 25px;
  right: 25px;
  border-radius: 16px;
}
button{
  position: relative;
  margin: 0px;
  border: none;
  width: 70px;
  height: 70px;
  color: white;
  background-size: 64px 64px;
  background-position: center 6px;
  background-repeat: no-repeat;
  background-color: transparent;
  font-size: 14px;
  padding-top: 72px;
  font-weight: 700;
  text-shadow: -1px 0 0 rgba(0, 0, 0, 0.8),
  1px 0 0 rgba(0, 0, 0, 0.8),
  0 -1px 0 rgba(0, 0, 0, 0.8),
  0 1px 0 rgba(0, 0, 0, 0.8);
  text-align: center;
  border-radius: 12px !important;
  outline: none;
}

button .puce{

    position: absolute;
    display: block;
    background-color: #f94b42;
    font-size: 14px;
    width: 28px;
    height: 28px;
    line-height: 28px;
    text-align: center;
    border-radius: 50%;
    bottom: 44px;
    right: -2px;
}

button.select, button:hover{
  background-color: rgba(240,240,240, .2);
  border-radius: 8px;
}

.btn_menu_ctn{
  width: 100%;
  display: flex;
  height: 80px;
  justify-content: center;
  align-content: center;
}
.btn_menu {
  height: 50px;
}

button[name="téléphone"] {

}

button[name="messages"] {

}

button[name="contacts"] {

}


button[name="paramètres"] {

}

.special_menu {
  height: 7px;
  width: 200px;
  background-color: white;
  position: absolute;
  bottom: -39px;
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
.time{
    padding-right: 12px;
    position: absolute;
    top: 87px;
    left: 0;
    right: 0;
    margin: auto;
    text-align: center;
    font-size: 64px;
    color: rgba(255, 255, 255, .85);
}
</style>
