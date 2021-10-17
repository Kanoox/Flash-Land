<template>
  <div class="phone_app">
    <PhoneTitle :title="title" :showInfoBare="showInfoBare" v-if="showHeader" @back="back"/>
    <!-- <InfoBare v-if="showInfoBare"/>
    <div v-if="title !== ''" class="phone_title" v-bind:style="styleTitle()">{{title}}</div>
    -->
    <div v-if="this.$route.name === 'messages'" @click="openApp({routeName: 'messages.selectcontact'})" class="nouveau_msg">
      <img src="/html/static/img/icons_app/new_msg.png" alt="new_msg">
    </div>

    <div v-if="this.$route.name === 'contacts'" @click="openApp({routeName: 'contacts.view'})" class="nouveau_contact">
      <img src="/html/static/img/icons_app/new_contact.png" alt="new_contact">
    </div>

    <div class="phone_content elements">
        <div class="element" v-for='(elem, key) in list'
          v-bind:name="elem.named"
          v-bind:key="elem[keyDispay]"
          v-bind:class="{ select: key === currentSelect}"
          @click.stop="selectItem(elem)"
          @contextmenu.prevent="optionItem(elem)"
          >
            <div class="elem-pic" v-bind:style="stylePuce(elem)" @click.stop="selectItem(elem)">
              <!-- {{elem.letter || elem[keyDispay][0]}} -->
            </div>
            <div @click.stop="selectItem(elem)" v-if="elem.puce !== undefined && elem.puce !== 0" class="elem-puce"></div>
            <div @click.stop="selectItem(elem)"  class="elem-title-has-desc">{{elem[keyDispay]}}</div>
            <div @click.stop="selectItem(elem)" v-if="elem.keyDesc !== undefined && elem.keyDesc !== ''" class="elem-description">{{elem.keyDesc}}</div>
        </div>
    </div>
  </div>
</template>

<script>
import PhoneTitle from './PhoneTitle'
import InfoBare from './InfoBare'
import { mapGetters } from 'vuex'

export default {
  name: 'hello',
  components: {
    PhoneTitle, InfoBare
  },
  data: function () {
    return {
      currentSelect: 0
    }
  },
  props: {
    title: {
      type: String,
      default: 'Title'
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
  watch: {
    list: function () {
      this.currentSelect = 0
    }
  },
  computed: {
    ...mapGetters(['useMouse'])
  },
  methods: {
    openApp (app) {
      this.$router.push({ name: app.routeName })
    },
    styleTitle: function () {
      return {
        color: this.color,
        backgroundColor: this.backgroundColor
      }
    },
    stylePuce (data) {
      data = data || {}
      if (data.icon !== undefined) {
        return {
          backgroundImage: `url(${data.icon})`,
          backgroundSize: 'cover',
          color: 'rgba(0,0,0,0)',
          borderRadius: '50%'
        }
      }
      if (data.named === 'new_msg') {
        return {}
      }
      return {
        color: data.color || this.color,
        backgroundColor: 'rgb(155, 159, 170)',
        borderRadius: '50%',
        backgroundSize: 'cover',
        backgroundImage: 'url(\'/html/static/img/icons_app/defaultIcon.png\')'
      }
    },
    scrollIntoViewIfNeeded: function () {
      this.$nextTick(() => {
        document.querySelector('.select').scrollIntoViewIfNeeded()
      })
    },
    onUp: function () {
      if (this.disable === true) return
      this.currentSelect = this.currentSelect === 0 ? this.list.length - 1 : this.currentSelect - 1
      this.scrollIntoViewIfNeeded()
    },
    onDown: function () {
      if (this.disable === true) return
      this.currentSelect = this.currentSelect === this.list.length - 1 ? 0 : this.currentSelect + 1
      this.scrollIntoViewIfNeeded()
    },
    onN: function () {
      if (this.$route.name === 'messages') {
        this.openApp({routeName: 'messages.selectcontact'})
      } else if (this.$route.name === 'contacts') {
        this.openApp({routeName: 'contacts.view'})
      }
    },
    selectItem (item) {
      this.$emit('select', item)
    },
    optionItem (item) {
      this.$emit('option', item)
    },
    back () {
      this.$emit('back')
    },
    onRight: function () {
      if (this.disable === true) return
      this.$emit('option', this.list[this.currentSelect])
    },
    onEnter: function () {
      if (this.disable === true) return
      this.$emit('select', this.list[this.currentSelect])
    }
  },
  created: function () {
    if (!this.useMouse) {
      this.$bus.$on('keyUpArrowDown', this.onDown)
      this.$bus.$on('keyUpArrowUp', this.onUp)
      this.$bus.$on('keyUpArrowRight', this.onRight)
      this.$bus.$on('keyUpEnter', this.onEnter)
      this.$bus.$on('keyUp+', this.onN)
    } else {
      this.currentSelect = -1
    }
  },
  beforeDestroy: function () {
    this.$bus.$off('keyUpArrowDown', this.onDown)
    this.$bus.$off('keyUpArrowUp', this.onUp)
    this.$bus.$off('keyUpArrowRight', this.onRight)
    this.$bus.$off('keyUpEnter', this.onEnter)
    this.$bus.$off('keyUp+', this.onN)
  }
}
</script>

<style scoped>
.list{
  height: 100%;
}


.elements{
  overflow-y: auto;
}

.element{
  display: -ms-flexbox;
  display: flex;
  -ms-flex-align: center;
  align-items: center;
  position: relative;
  padding-top: 20px;
  padding-bottom: 20px;
  border-bottom: 1px solid rgb(50, 50, 50, 1);
}

.element.select, .element:hover {
   background-color: rgba(255, 255, 255, .2);
}

.elem-pic{
  margin-left: 28px;
  height: 48px;
  width: 48px;
  text-align: center;
  line-height: 48px;
  font-weight: 700;
}
.elem-puce{
  background-color: #3A82F7;
    color: white;
    height: 12px;
    width: 12px;
    line-height: 18px;
    border-radius: 50%;
    text-align: center;
    font-size: 14px;
    margin: 0px;
    padding: 0px;
    position: absolute;
    left: 8px;
    top: 0;
    bottom: 0;
    margin: auto;
    z-index: 6;
}
.elem-title{
  margin-left: 12px;
}
.elem-title-has-desc {
    margin-top: -30px;
    margin-left: 12px;
    color: white;
    font-size: 19px;
    font-weight: bold;
}
.elem-description{
  text-align: left;
  color: rgba(255, 255, 255, .50);
  position: absolute;
  display: block;
  width: 75%;
  left: 88px;
  top: 41px;
  font-size: 12.5px;
  overflow: hidden;
  text-overflow: ellipsis;
  font-weight: bold;
  height: 42px;
  letter-spacing: -0.5px;
}

div[name="new_msg"] {
  position: relative;
  height: 60px;
  display: none;
}

div[name="new_msg"]:hover, div[name="new_msg"].select {
  background-color: rgb(58, 130, 247);
}

/* div[name="new_msg"]:hover, div[name="new_msg"].select {
  background-color: rgb(58, 130, 247);
}
*/

div[name="new_msg"] > .elem-pic {
  position: absolute;
  background: red;
  background-size: cover;
  background-image: url('/html/static/img/icons_app/new_msg.png');
}

/* NEW MSG */

div.nouveau_msg {
  position: absolute;
  right: 20px; top: 60px;
  height: 38px; width: 38px;
  background: rgba(58, 130, 247, .70);
  border-radius: 50%;
  text-align: center;
  line-height: 40px;
  color: white;
  cursor: pointer;
  transition: 0.2s;
}

div.nouveau_msg:hover {
  background: rgba(58, 130, 247, 1);
}

div.nouveau_msg > img {
  position: absolute;
  top: 0; bottom: 0;
  left: 0; right: 0;
  margin: auto;
  height: 20px;
}

/* NEW CONTACT */

div.nouveau_contact {
  position: absolute;
  right: 20px; top: 60px;
  height: 38px; width: 38px;
  background: rgba(58, 130, 247, .70);
  border-radius: 50%;
  text-align: center;
  line-height: 40px;
  color: white;
  cursor: pointer;
  transition: 0.2s;
}

div.nouveau_contact:hover {
  background: rgba(58, 130, 247, 1);
}

div.nouveau_contact > img {
  position: absolute;
  top: 0; bottom: 0;
  left: 0; right: 0;
  margin: auto;
  height: 20px;
}

</style>
