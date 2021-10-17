<template>
  <div style="background:rgb(22, 22, 22)" class="phone_title_content" :class="{'hasInfoBare': showInfoBare}" >
    <InfoBare v-if="showInfoBare" />
    <div class="phone_title" style="height: 185px">
      <div style="color: white;position: absolute;top: 50px;left: 23px;font-size: 34px;font-weight: bold;letter-spacing: -0.5px;">{{title}}</div>
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
  computed: {
    ...mapGetters(['themeColor']),
    style () {
      return {
        backgroundColor: '#161616',
        color: this.color || '#FFF'
      }
    }
  },
  methods: {
    back () {
      this.$emit('back')
    }
  },
  props: {
    title: {
      type: String,
      required: true
    },
    showInfoBare: {
      type: Boolean,
      default: true
    },
    backgroundColor: {
      type: String
    }
  }
}
</script>
<style scoped>

</style>
