<template>
  <div class="calculator">
  	<div class="phone_app">
  	<PhoneTitle :title="IntlString('Calculatrice')" @back="quit" />
    <table cellspacing="10">
      <tr>
        <td colspan="4">
          <input type="text" v-model="result" disabled>
        </td>
      </tr>
      <tr>
        <td class="button dark" @click="clear">C</td>
        <td class="button dark" @click="invert">+/-</td>
        <td class="button dark" @click="percent">%</td>
        <td class="button orange" @click="setOperator('/')">/</td>
      </tr>
      <tr>
        <td class="button grey" @click="addNumber(7)">7</td>
        <td class="button grey" @click="addNumber(8)">8</td>
        <td class="button grey" @click="addNumber(9)">9</td>
        <td class="button orange" @click="setOperator('*')">*</td>
      </tr>
      <tr>
        <td class="button grey" @click="addNumber(4)">4</td>
        <td class="button grey" @click="addNumber(5)">5</td>
        <td class="button grey" @click="addNumber(6)">6</td>
        <td class="button orange" @click="setOperator('-')">-</td>
      </tr>
      <tr>
        <td class="button grey" @click="addNumber(1)">1</td>
        <td class="button grey" @click="addNumber(2)">2</td>
        <td class="button grey" @click="addNumber(3)">3</td>
        <td class="button orange" @click="setOperator('+')">+</td>
      </tr>
      <tr>
        <td class="button-col2 grey" @click="addNumber(0)" colspan="2">0</td>
        <td class="button grey" @click="addPoint">.</td>
        <td class="button orange" @click="equal">=</td>
      </tr>
    </table>
        <button
          class="special_menu"
          @click="openApp({routeName: 'menu'})"
          >
        </button>
    </div>
</div>
</div>
</template>

<script>
  import { mapGetters } from 'vuex'
  import PhoneTitle from './../PhoneTitle'

  export default {
    data: function () {
      return {
        numero: '',
        result: 0,
        tmp_value: 0,
        reset: false,
        operator: undefined,
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
    components: {
      PhoneTitle
    },
    computed: {
      ...mapGetters(['IntlString', 'useMouse', 'AppsHome'])
    },
    methods: {
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
      onBackspace () {
        this.$router.push({ name: 'menu' })
      },
      openApp (app) {
        this.$router.push({ name: app.routeName })
      },
      onEnter () {
        if (this.keySelect === 12) {
          if (this.numero.length > 0) {
            this.equal({ numero: this.numero })
          }
        } else {
          this.numero += this.keyInfo[this.keySelect].primary
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
      clear () {
        this.result = 0
        this.tmp_value = 0
        this.operator = undefined
      },
      invert () {
        this.result *= -1
      },
      percent () {
        this.result /= 100
      },
      addNumber (number) {
        if (this.result === 0 || this.reset === true) {
          this.result = ''
          this.reset = false
        }

        this.result += number.toString()
      },
      addPoint () {
        if (!this.result.includes('.')) {
          this.result += '.'
        }
      },
      setOperator (operator) {
        if (this.tmp_value !== 0) {
          this.calculate()
        }

        this.tmp_value = this.result
        this.operator = operator
        this.reset = true
      },
      equal () {
        this.calculate()
        this.tmp_value = 0
        this.operator = undefined
      },
      calculate () {
        let value = 0
        let firstNum = parseFloat(this.tmp_value)
        let secondNum = parseFloat(this.result)

        switch (this.operator) {
          case '+':
            value = firstNum + secondNum
            break
          case '-':
            value = firstNum - secondNum
            break
          case '*':
            value = firstNum * secondNum
            break
          case '/':
            value = firstNum / secondNum
        }

        this.result = value.toString()
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

<style lang="scss" scoped>
  .calculator {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    font-size: 3rem;

    input {
      display: block;
      width: calc(100% - 40px);
      height: 75px;
      padding: 5px 20px 0;
      margin-bottom: 10px;
      border: none;
      background-color: #222;
      color: #fff;
      font-size: 4rem;
      text-align: right;
    }

    .button {
      margin: 10px;
      border-radius: 40px;
      width: 80px;
      height: 80px;
      text-align: center;
      font-weight: bold;
      cursor: pointer;
    }

    .button-col2 {
      border-radius: 40px;
      width: 160px;
      height: 80px;
      text-align: center;
      font-weight: bold;
      cursor: pointer;
    }

    .grey {
      background-color: #ccc;
      color: #333;

      &:hover {
        background-color: #ddd;
      }
    }

    .dark {
      background-color: #444;
      color: #fff;

      &:hover {
        background-color: #555;
      }
    }

    .orange {
      background-color: #e08d1f;
      color: #fff;

      &:hover {
        background-color: #fda22b;
      }
    }
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
</style>

