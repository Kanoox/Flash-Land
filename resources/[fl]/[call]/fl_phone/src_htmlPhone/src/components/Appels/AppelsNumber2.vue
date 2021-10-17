

<template>
   <div class="phone_app">
    <PhoneTitle :title="IntlString('APP_PHONE_TITLE')" @back="quit" />
    <div class="content">
      <div class="number">
        {{ numeroFormat }}
        <span class="deleteNumber" @click.stop="deleteNumber">x</span>
      </div>

      <div class="keyboard">
        <div
          class="key"
          v-for="(key, i) of keyInfo" :key="key.primary"
          :class="{'key-select': i === keySelect, 'keySpe': key.isNotNumber === true}"
          @click.stop="onPressKey(key)"
        >
          <span @click.stop="onPressKey(key)" class="key-primary">{{key.primary}}</span>
          <span @click.stop="onPressKey(key)" class="key-secondary">{{key.secondary}}</span>
        </div>
      </div>

      <div class="call">
        <div class="call-btn" :class="{'active': keySelect === 12}"
          @click.stop="onPressCall">
        <svg viewBox="0 0 24 24" @click.stop="onPressCall">
          <g transform="rotate(0, 12, 12)">
          <path d="M6.62,10.79C8.06,13.62 10.38,15.94 13.21,17.38L15.41,15.18C15.69,14.9 16.08,14.82 16.43,14.93C17.55,15.3 18.75,15.5 20,15.5A1,1 0 0,1 21,16.5V20A1,1 0 0,1 20,21A17,17 0 0,1 3,4A1,1 0 0,1 4,3H7.5A1,1 0 0,1 8.5,4C8.5,5.25 8.7,6.45 9.07,7.57C9.18,7.92 9.1,8.31 8.82,8.59L6.62,10.79Z"/>
            </g>
        </svg>
        </div>
      </div>
    </div>
    <div class='home_buttons'>
      <div class="btn_menu_ctn">
        <button
          class="btn_menu special_menu"
          :class="{ select: AppsHome.length === currentSelect}"
          @click="openApp({routeName: 'appels'})"
          >
        </button>
      </div>
    </div>
   </div>
</template>

<script>
import { mapActions, mapGetters } from 'vuex'
import PhoneTitle from './../PhoneTitle'
export default {
  components: {
    PhoneTitle
  },
  data () {
    return {
      numero: '',
      keyInfo: [
        {primary: '1', secondary: '‏‏‎ ‎‎'},
        {primary: '2', secondary: 'abc'},
        {primary: '3', secondary: 'def'},
        {primary: '4', secondary: 'ghi'},
        {primary: '5', secondary: 'jkl'},
        {primary: '6', secondary: 'mmo'},
        {primary: '7', secondary: 'pqrs'},
        {primary: '8', secondary: 'tuv'},
        {primary: '9', secondary: 'wxyz'},
        {primary: '-', secondary: '‏‏‎ ‎'},
        {primary: '0', secondary: '‏‏‎+'},
        {primary: '#', secondary: '‏‏‎ ‎'}
      ],
      keySelect: 0
    }
  },
  methods: {
    ...mapActions(['startCall']),
    onOne () {
      this.numero += '1'
    },
    onTwo () {
      this.numero += '2'
    },
    onThree () {
      this.numero += 3
    },
    onFour () {
      this.numero += 4
    },
    onFive () {
      this.numero += 5
    },
    onSix () {
      this.numero += 6
    },
    onSeven () {
      this.numero += 7
    },
    onEight () {
      this.numero += 8
    },
    onNine () {
      this.numero += 9
    },
    onZero () {
      this.numero += 0
    },
    onLeft () {
      this.keySelect = Math.max(this.keySelect - 1, 0)
    },
    onRight () {
      this.keySelect = Math.min(this.keySelect + 1, 11)
    },
    onDown () {
      this.keySelect = Math.min(this.keySelect + 3, 12)
    },
    onUp () {
      if (this.keySelect > 2) {
        if (this.keySelect === 12) {
          this.keySelect = 10
        } else {
          this.keySelect = this.keySelect - 3
        }
      }
    },
    openApp (app) {
      this.$router.push({ name: app.routeName })
    },
    onEnter () {
      if (this.keySelect === 12) {
        if (this.numero.length > 0) {
          this.startCall({ numero: this.numeroFormat })
        }
      } else {
        this.numero += this.keyInfo[this.keySelect].primary
      }
    },
    onBackspace: function () {
      if (this.ignoreControls === true) return
      if (this.numero.length !== 0) {
        this.numero = this.numero.slice(0, -1)
      } else {
        history.back()
      }
    },
    deleteNumber () {
      if (this.numero.length !== 0) {
        this.numero = this.numero.slice(0, -1)
      }
    },
    onPressKey (key) {
      this.numero = this.numero + key.primary
    },
    onPressCall () {
      this.startCall({ numero: this.numeroFormat })
    },
    quit () {
      history.back()
    }
  },

  computed: {
    ...mapGetters(['IntlString', 'useMouse', 'useFormatNumberFrance', 'AppsHome']),
    numeroFormat () {
      if (this.useFormatNumberFrance === true) {
        return this.numero
      }
      const l = this.numero.startsWith('#') ? 4 : 3
      if (this.numero.length > l) {
        return this.numero.slice(0, l) + '' + this.numero.slice(l)
      } else {
        return this.numero
      }
    }
  },

  created () {
    if (!this.useMouse) {
      this.$bus.$on('keyUpBackspace', this.onBackspace)
      this.$bus.$on('keyUpArrowLeft', this.onLeft)
      this.$bus.$on('keyUpArrowRight', this.onRight)
      this.$bus.$on('keyUpArrowDown', this.onDown)
      this.$bus.$on('keyUpArrowUp', this.onUp)
      this.$bus.$on('keyUpEnter', this.onEnter)
      this.$bus.$on('keyUp1', this.onOne)
      this.$bus.$on('keyUp2', this.onTwo)
      this.$bus.$on('keyUp3', this.onThree)
      this.$bus.$on('keyUp4', this.onFour)
      this.$bus.$on('keyUp5', this.onFive)
      this.$bus.$on('keyUp6', this.onSix)
      this.$bus.$on('keyUp7', this.onSeven)
      this.$bus.$on('keyUp8', this.onEight)
      this.$bus.$on('keyUp9', this.onNine)
      this.$bus.$on('keyUp0', this.onZero)
    } else {
      this.keySelect = -1
    }
  },
  beforeDestroy () {
    this.$bus.$off('keyUpBackspace', this.onBackspace)
    this.$bus.$off('keyUpArrowLeft', this.onLeft)
    this.$bus.$off('keyUpArrowRight', this.onRight)
    this.$bus.$off('keyUpArrowDown', this.onDown)
    this.$bus.$off('keyUpArrowUp', this.onUp)
    this.$bus.$off('keyUpEnter', this.onEnter)
    this.$bus.$off('keyUp1', this.onOne)
    this.$bus.$off('keyUp2', this.onTwo)
    this.$bus.$off('keyUp3', this.onThree)
    this.$bus.$off('keyUp4', this.onFour)
    this.$bus.$off('keyUp5', this.onFive)
    this.$bus.$off('keyUp6', this.onSix)
    this.$bus.$off('keyUp7', this.onSeven)
    this.$bus.$off('keyUp8', this.onEight)
    this.$bus.$off('keyUp9', this.onNine)
    this.$bus.$off('keyUp0', this.onZero)
  }
}
</script>

<style scoped>


.number{
  position: absolute;
  top: -80px;
  width: 500px;
  height: 52px;
  font-size: 35px;
  line-height: 52px;
  text-align: center;
  position: relative;
  margin-top: 10px;
  padding-right: 60px;
  color: white;
}
.keyboard {
  position: absolute;
  top: 230px;
  display: inline-block;
  width: 400px;
  left: 0; right: 0;
  margin: auto;
  text-align: center;
}
.key {
  position: relative;
  text-align: center;
  top:-25px;
  display: inline-block;
  margin-left: 5px;
  margin-right: 5px;
  height: calc(400px / 4);
  margin-top: 5px;
  margin-bottom: 5px;
  width: calc(400px / 4);
  background: rgba(100, 100, 100, .75);
  border-radius: 50%;
}

.key-select::after, .key:hover::after {
  content: '';
  position: absolute;
  top: calc(50% - 50px);
  left: calc(50% - 50px);
  display: block;
  width: calc(400px / 4);
  height: calc(400px / 4);
  border-radius: 50%;
  background: rgba(82, 214, 106, .5);
}

.key-primary {
  display: block;
  font-size: 36px;
  color: white;
  line-height: 20px;
  padding-top: 36px;
}
.keySpe .key-primary {
  color: white;
  line-height: 96px;
  padding: 0;
}

.key-secondary {
  text-transform: uppercase;
  display: block;
  font-size: 12px;
  color: white;
  line-height: 12px;
  padding-top: 6px;
}
.call {
  margin-top: 18px;
  display: flex;
  justify-content: center;
}
.call-btn {
  position: absolute;
  bottom: 180px;
  height: 70px;
  width: 70px;
  border-radius: 50%;
  background-color: #52d66a;
}
.call-btn.active, .call-btn:hover {
  background-color: #43a047;
}
.call-btn svg {
  position: absolute;
  width: 50px;
  height: 50px;
  margin: 10px;
  fill: #EEE;
}
.deleteNumber {
  display: inline-block;
  position: absolute;
  background: rgba(100, 100, 100, .75);
  bottom: -545px;
  right: 155px;
  height: 18px;
  width: 20px;
  border-top-right-radius: 3px;
  border-bottom-right-radius: 3px;
  padding: 0;
  text-align: center;
  line-height: 15px;
  font-size: 20px;
}
.deleteNumber:after {
  content: '';
  position: absolute;
  left: -10px;
  top:0;
  width: 0;
  height: 0;
  border-style: solid;
  border-width: 9px 10px 9px 0;
  border-color: transparent rgba(100, 100, 100, .75) transparent transparent;
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
