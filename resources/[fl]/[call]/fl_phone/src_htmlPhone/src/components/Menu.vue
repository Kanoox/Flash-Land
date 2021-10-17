<template>
  <div class="phone_app">
    <div class="backblur" v-bind:style="{background: 'url(' + backgroundURL +')'}"></div>
    <InfoBare class="infobare"/>
    <div class="menu">

      <div class="menu_content">

          <div class='menu_buttons'>
            <button
                v-for="(but, key) of Apps"
                v-bind:key="but.name"
                v-bind:class="{ select: key === currentSelect}"
                v-bind:style="{backgroundImage: 'url(' + but.icons +')'}"
                @click.stop="openApp(but)"
              >
                {{but.intlName}}
                <span class="puce" v-if="but.puce !== undefined && but.puce !== 0">{{but.puce}}</span>
            </button>
          </div>
      </div>
      <button
          class="special_menu"
          :class="{ select: Apps.length === currentSelect}"
          @click="openApp({routeName: 'home'})"
          >
        </button>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import InfoBare from './InfoBare'

export default {
  components: {
    InfoBare
  },
  data: function () {
    return {
      currentSelect: 0
    }
  },
  computed: {
    ...mapGetters(['nbMessagesUnread', 'backgroundURL', 'Apps', 'useMouse', 'AppsHome'])
  },
  methods: {
    ...mapGetters(['closePhone']),
    onLeft: function () {
      const l = Math.floor(this.currentSelect / 4)
      const newS = (this.currentSelect + 4 - 1) % 4 + l * 4
      this.currentSelect = Math.min(newS, this.Apps.length - 1)
    },
    onRight: function () {
      const l = Math.floor(this.currentSelect / 4)
      let newS = (this.currentSelect + 1) % 4 + l * 4
      if (newS >= this.Apps.length) {
        newS = l * 4
      }
      this.currentSelect = newS
    },
    onUp: function () {
      let newS = this.currentSelect - 4
      if (newS < 0) {
        const r = this.currentSelect % 4
        newS = Math.floor((this.Apps.length - 1) / 4) * 4
        this.currentSelect = Math.min(newS + r, this.Apps.length - 1)
      } else {
        this.currentSelect = newS
      }
    },
    onDown: function () {
      const r = this.currentSelect % this.Apps.length
      let newS = this.currentSelect + 4
      if (newS >= this.Apps.length) {
        newS = r
      }
      this.currentSelect = newS
    },
    openApp (app) {
      this.$router.push({ name: app.routeName })
    },
    onEnter () {
      this.openApp(this.Apps[this.currentSelect])
    },
    onBack: function () {
      this.$router.push({ name: 'home' })
    }
  },
  mounted () {
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

<style scoped>
.menu{
  position: relative;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  padding: 6px 8px;
}
.backblur{
  top: -6px;
  left: -6px;
  right:-6px;
  bottom: -6px;
  position: absolute;
  background-size: cover !important;
  background-position: center !important;
  filter: blur(2px);
}
.menu_content {
  display: flex;
  flex-direction: column;
}

.menu_buttons{
  margin-top: 20px;
  display: flex;
  width: 100%;
  align-items: flex-start;
  align-content: flex-start;
  /* justify-content: space-around; */
  flex-flow: row;
  flex-wrap: wrap;
  margin-bottom: 0px;

  transition: all 0.5s ease-in-out;
}

.menu_buttons {
  animation-name: up;
  animation-duration: 0.6s;
  animation-fill-mode: forwards;
}
@keyframes up {
  from {transform: translateY(100vh);}
  to {transform: translateY(0);}
}

.btn_menu_ctn{
  width: 100%;
  display: flex;
  height: 80px;
  justify-content: center;
  align-content: center;
}
button{
  position: relative;
  margin: 0px;
  border: none;
  width: 80px;
  height: 110px;
  margin: 8px;
  color: white;
  background-size: 64px 64px;
  background-position: center 6px;
  background-repeat: no-repeat;
  background-color: transparent;
  font-size: 12px;
  padding-top: 72px;
  font-weight: 700;
  text-shadow: -1px 0 0 rgba(0,0,0, 0.8),
             1px 0 0 rgba(0,0,0, 0.8),
             0 -1px 0 rgba(0,0,0, 0.8),
             0 1px 0 rgba(0,0,0, 0.8);
  text-align: center;
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
  top: -2px;
  right: 0px;
}
button.select, button:hover{
  background-color: rgb(255 255 255 / 5%);
  border-radius: 7px;
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
