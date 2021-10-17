<template>
  <div class="phone_app">
    <PhoneTitle :title="contact.display" @back="forceCancel"/>
    <div class='phone_content content inputText'>

        <div class="group inputText select" data-type="text" data-model='display' data-maxlength = '64'>
            <input type="text" v-model="contact.display" maxlength="64" v-autofocus>
            <span class="highlight"></span>
            <span class="bar"></span>
            <label>{{ IntlString('APP_CONTACT_LABEL_NAME') }}</label>
        </div>

        <div class="group inputText" data-type="text" data-model='number' data-maxlength='10'>
            <input type="text" v-model="contact.number" maxlength="10">
            <span class="highlight"></span>
            <span class="bar"></span>
            <label>{{ IntlString('APP_CONTACT_LABEL_NUMBER') }}</label>
        </div>
        <div class="group btn-vert" data-type="button" data-action='save' @click.stop="save">
            <input style="font-weight: 100;" type='button' class="btn btn-green" :value="IntlString('APP_CONTACT_SAVE')" @click.stop="save"/>
        </div>
        <div class="group btn-orange" data-type="button" data-action='cancel' @click.stop="forceCancel">
            <input  style="font-weight: 100;" type='button' class="btn btn-orange" :value="IntlString('APP_CONTACT_CANCEL')" @click.stop="forceCancel"/>
        </div>
        <div class="group btn-rouge" data-type="button" data-action='deleteC' @click.stop="deleteC">
            <input style="font-weight: 100;" type='button' class="btn btn-red" :value="IntlString('APP_CONTACT_DELETE')" @click.stop="deleteC"/>
        </div>
    </div>
        <button
          class="special_menu"
          @click="openApp({routeName: 'contacts'})"
          >
        </button>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import PhoneTitle from './../PhoneTitle'
import Modal from '@/components/Modal/index.js'

export default {
  components: {
    PhoneTitle
  },
  data () {
    return {
      id: -1,
      currentSelect: 0,
      ignoreControls: false,
      contact: {
        display: '',
        number: '',
        id: -1
      }
    }
  },
  computed: {
    ...mapGetters(['IntlString', 'contacts', 'useMouse', 'AppsHome'])
  },
  methods: {
    ...mapActions(['updateContact', 'addContact']),
    onUp () {
      if (this.ignoreControls === true) return
      let select = document.querySelector('.group.select')
      if (select.previousElementSibling !== null) {
        document.querySelectorAll('.group').forEach(elem => {
          elem.classList.remove('select')
        })
        select.previousElementSibling.classList.add('select')
        let i = select.previousElementSibling.querySelector('input')
        if (i !== null) {
          i.focus()
        }
      }
    },
    openApp (app) {
      this.$router.push({ name: app.routeName })
    },
    onDown () {
      if (this.ignoreControls === true) return
      let select = document.querySelector('.group.select')
      if (select.nextElementSibling !== null) {
        document.querySelectorAll('.group').forEach(elem => {
          elem.classList.remove('select')
        })
        select.nextElementSibling.classList.add('select')
        let i = select.nextElementSibling.querySelector('input')
        if (i !== null) {
          i.focus()
        }
      }
    },
    onEnter () {
      if (this.ignoreControls === true) return
      let select = document.querySelector('.group.select')
      if (select.dataset.type === 'text') {
        let options = {
          limit: parseInt(select.dataset.maxlength) || 64,
          text: this.contact[select.dataset.model] || ''
        }
        this.$phoneAPI.getReponseText(options).then(data => {
          this.contact[select.dataset.model] = data.text
        })
      }
      if (select.dataset.action && this[select.dataset.action]) {
        this[select.dataset.action]()
      }
    },
    save () {
      if (!this.contact.display || !this.contact.number) return
      if (this.id === -1 || this.id === 0) {
        this.addContact({
          display: this.contact.display,
          number: this.contact.number
        })
      } else {
        this.updateContact({
          id: this.id,
          display: this.contact.display,
          number: this.contact.number
        })
      }
      history.back()
    },
    cancel () {
      if (this.ignoreControls === true) return
      if (this.useMouse === true && document.activeElement.tagName !== 'BODY') return
      history.back()
    },
    forceCancel () {
      history.back()
    },
    deleteC () {
      if (this.id !== -1) {
        this.ignoreControls = true
        let choix = [{title: 'Annuler'}, {title: 'Annuler'}, {title: 'Supprimer', color: 'red'}, {title: 'Annuler'}, {title: 'Annuler'}]
        Modal.CreateModal({choix}).then(reponse => {
          this.ignoreControls = false
          if (reponse.title === 'Supprimer') {
            this.$phoneAPI.deleteContact(this.id)
            history.back()
          }
        })
      } else {
        history.back()
      }
    }
  },
  created () {
    if (!this.useMouse) {
      this.$bus.$on('keyUpArrowDown', this.onDown)
      this.$bus.$on('keyUpArrowUp', this.onUp)
      this.$bus.$on('keyUpEnter', this.onEnter)
    } else {
      this.currentSelect = -1
    }
    this.$bus.$on('keyUpBackspace', this.cancel)
    this.id = parseInt(this.$route.params.id)
    this.contact.display = this.IntlString('APP_CONTACT_NEW')
    this.contact.number = this.$route.params.number
    if (this.id !== -1) {
      const c = this.contacts.find(e => e.id === this.id)
      if (c !== undefined) {
        this.contact = {
          id: c.id,
          display: c.display,
          number: c.number
        }
      }
    }
  },
  beforeDestroy: function () {
    this.$bus.$off('keyUpArrowDown', this.onDown)
    this.$bus.$off('keyUpArrowUp', this.onUp)
    this.$bus.$off('keyUpEnter', this.onEnter)
    this.$bus.$off('keyUpBackspace', this.cancel)
  }
}
</script>

<style scoped>
.contact{
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
    background-color: #5264AE;
    color: white;
}
.content{
    margin-top: 28px;
}
.group {
  position:relative;
  margin-top:24px;
}
.group.inputText {
  position:relative;
  margin-top:45px;
  padding: 10px;
  text-indent: 10px;
  background-color: rgb(100, 100, 100);
}
.group.select {
  position:relative;
  text-indent: 10px;
}
input 				{
  font-size:24px;
  padding: 10px;
  border-radius: 20px;
  display:block;
  width:100%;
  border:none;
  background: rgb(100, 100, 100);
  color: white;
  font-weight: 100;
  font-size: 20px;
}
input:focus 		{ outline:none; }

/* LABEL ======================================= */
label 				 {
  color:rgba(255, 255, 255, .75);
  font-size:18px;
  font-weight:normal;
  position:absolute;
  pointer-events:none;
  left:5px;
  top:10px;
  transition:0.2s ease all;
  -moz-transition:0.2s ease all;
  -webkit-transition:0.2s ease all;
}

/* active state */
input:focus ~ label, input:valid ~ label 		{
  top:-24px;
  font-size:18px;
  color:gray;
}

/* BOTTOM BARS ================================= */
.bar 	{ position:relative; display:block; width:100%; }
.bar:before, .bar:after 	{
  content:'';
  height:3px;
  width:0;
  bottom:1px;
  position:absolute;
  transition:0.2s ease all;
  -moz-transition:0.2s ease all;
  -webkit-transition:0.2s ease all;
}
.bar:before {
  left:50%;
}
.bar:after {
  right:50%;
}

/* active state */
input:focus ~ .bar:before, input:focus ~ .bar:after,
.group.select input ~ .bar:before, .group.select input ~ .bar:after{
  width:50%;
}


.group .btn{
    width: 100%;
    padding: 0px 0px;
    height: 48px;
    color: #fff;
    border: 0 none;
    font-size: 22px;
    font-weight: 500;
    line-height: 34px;
    color: #202129;
    background-color: #edeeee;
}
.group.select .btn{
    /* border: 6px solid #C0C0C0; */
    line-height: 18px;
}

.group .btn.btn-green{
  position: relative;
  width: 410px;
  left: 0; right: 0;
  margin: auto;
  border: 1px solid #27ae60;
  color: #27ae60;
  background-color: #27ae60;
  font-weight: 500;
  color: white;
  border-radius: 28px;
}

.group.select {
  background: rgba(255, 255, 255, .2);
}

.group.btn-vert.select {
  background: rgba(39, 174, 96, .2);
}

.group.btn-rouge.select {
  background: rgba(231, 76, 60, .2)
}

.group.select .btn.btn-green, .group:hover .btn.btn-green{
  color: white;
}
.group .btn.btn-orange{
  border: 1px solid #B6B6B6;
  color: #B6B6B6;
  background-color: #B6B6B6;
  font-weight: 500;
  color: white;
  border-radius: 28px;
  width: 410px;
  left: 0; right: 0;
  margin: auto;
}
.group.select .btn.btn-orange, .group:hover .btn.btn-orange{
  color: white;
  border: #B6B6B6;
}

.group .btn.btn-red{
  border: 1px solid #e74c3c;
  background-color: #e74c3c;
  font-weight: 500;
  border-radius: 28px;
  color: white;
  width: 410px;
  left: 0; right: 0;
  margin: auto;
}
.group.select .btn.btn-red, .group:hover .btn.btn-red{
  background-image: #c0392b;
  color: white;
  border: none;
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

/* ANIMATIONS ================ */
@-webkit-keyframes inputHighlighter {
	from { background:#5264AE; }
  to 	{ width:0; background:transparent; }
}
@-moz-keyframes inputHighlighter {
	from { background:#5264AE; }
  to 	{ width:0; background:transparent; }
}
@keyframes inputHighlighter {
	from { background:#5264AE; }
  to 	{ width:0; background:transparent; }
}
</style>

