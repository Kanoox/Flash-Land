<template>
  <div class="phone_app">
    <PhoneTitle :title="title" :showInfoBare="showInfoBare" v-if="showHeader" @back="quit"/>
    <div class="stopwatch-wrapper">

      <h1 class="seconds">{{ msToTime }}</h1>

      <div class="stopwatch-controls">
        <button class="btn btn--start" @click="startTimer();setBtn('start')" :name="[running]">Start</button>
        <button class="btn btn--stop" @click="stopTimer();setBtn('stop')" :name="[running === false && elapsed !== 0 ? true : false]">Stop</button>
        <button class="btn btn--reset" @click="resetTimer();setBtn('reset')">Reset</button>
      </div>

    </div>
        <button
          class="special_menu"
          @click="openApp({routeName: 'menu'})"
          >
        </button>
  </div>
</template>

<script>
import PhoneTitle from './../PhoneTitle'
import InfoBare from './../InfoBare'
import { mapGetters } from 'vuex'

export default {
  components: {
    PhoneTitle, InfoBare
  },
  name: 'Stopwatch',
  data () {
    return {
      elapsed: 0,
      timer: false,
      running: false,
      msg: 'Welcome to Your Vue.js App'
    }
  },
  props: {
    title: {
      type: String,
      default: 'Timer'
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
    ...mapGetters(['AppsHome', 'useMouse']),
    msToTime () {
      let s = this.elapsed
      function pad (n, z) {
        z = z || 2
        return ('00' + n).slice(-z)
      }
      var ms = s % 1000
      s = (s - ms) / 1000
      var secs = s % 60
      s = (s - secs) / 60
      var mins = s % 60
      var hrs = (s - mins) / 60
      return pad(hrs) + ':' + pad(mins) + ':' + pad(secs) + '.' + pad(ms, 3)
    }
  },
  created () {
    if (!this.useMouse) {
      this.$bus.$on('keyUpBackspace', this.onBackspace)
      this.$bus.$on('keyUpEnter', this.onEnter)
    }
  },
  beforeDestroy () {
    this.$bus.$off('keyUpBackspace', this.onBackspace)
    this.$bus.$off('keyUpEnter', this.onEnter)
  },
  destroyed () {
    clearInterval(this.timer)
  },
  methods: {
    openApp (app) {
      this.$router.push({ name: app.routeName })
    },
    tick () {
      this.elapsed = this.elapsed + 50
    },
    startTimer () {
      let vm = this
      clearInterval(this.timer)
      this.timer = setInterval(vm.tick, 50)
      this.running = true
    },
    stopTimer () {
      clearInterval(this.timer)
      this.running = false
    },
    resetTimer () {
      this.elapsed = 0
      clearInterval(this.timer)
      this.running = false
    },
    // unSelectAll () {
    //   let getAllsButtons = document.getElementsByTagName('button')
    //   for (var i = 0; i <= getAllsButtons.length - 2; i++) {
    //     getAllsButtons[i].classList.remove('select')
    //   }
    // },
    // setBtn: function (elem) {
    //   this.unSelectAll()
    //   document.getElementsByClassName('btn--' + elem)[0].classList.add('select')
    // },
    quit () {
      history.back()
    },
    onBackspace: function () {
      history.back()
    },
    onEnter: function () {
      let vm = this
      console.log(vm)
      if (!vm.running && vm.elapsed === 0) {
        vm.startTimer()
      } else if (vm.running && vm.elapsed !== 0) {
        vm.stopTimer()
      } else if (!vm.running && vm.elapsed !== 0) {
        vm.startTimer()
      }
    }
  }
}
</script>

<style scoped>

.stopwatch-controls {
  position: absolute;
  left: 0; right: 0;
  text-align: center;
  top: 500px;
}

.seconds {
  position: absolute;
  left: 50px; right: 50px;
  top: 300px;
  text-align: center;
  color: white;
  padding-top: 10px;
  padding-bottom: 10px;
  background:#62ae85;
}

.stopwatch-controls .btn {
  cursor: pointer;
  appearance: none;
  border: none;
  background-color: #62ae85;
  color: white;
  font-size: 1.4rem;
  padding-top: 15px;
  padding-bottom: 15px;
  border-radius: 4px;
  width: calc(400px / 3);
  text-align: center;
  overflow: hidden;
  border-top: 2px solid #a5d1b9;
  border-right: 1px solid #a5d1b9;
  border-left: 1px solid #4b926c;
  border-bottom: 0.5rem solid #4b926c;
  transform: translate3d(0, -10px, 0);
  transition: all 0.25s ease-out;
  will-change: transform;
  font-weight: bold;
}

.stopwatch-controls .btn:focus, .stopwatch-controls .btn:hover {
  outline: none;
  background-color: #73b792;
}

.stopwatch-controls .btn[name="true"] {
  transform: translate3d(0, 0px, 0);
  border-bottom: 0.05rem solid #4b926c;
}

.stopwatch-controls

.stopwatch-controls .btn.running {
  transform: translate3d(0, 0px, 0);
  border-bottom: 0.05rem solid #4b926c;
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

button.select {
  background: #4b9278 !important;
}
</style>
