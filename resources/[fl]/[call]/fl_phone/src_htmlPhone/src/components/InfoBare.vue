<template>
  <div class='phone_infoBare barre-header'>
    <span class="time">
    </span>
    {{config.reseau}}
    <template v-if="isAirplaneMode">
        <img alt="img_airplane" src="/html/static/img/icons_app/airplane.png" height="15">
    </template>

    <template v-else>
        <img alt="img_wifi" src="/html/static/img/icons_bar/wifi.png" height="15">
        <img alt="img_4g" src="/html/static/img/icons_bar/4g.png" height="15">
    </template>
    <img alt="img_battery" src="/html/static/img/icons_bar/batterie.png" height="15">
  </div>
</template>
<script>
import { mapGetters } from 'vuex'
export default {
  computed: mapGetters(['config', 'isAirplaneMode']),
  components: {
  }
}
</script>
<style scoped>
.barre-header {
    height: 24px;
    font-size: 17px;
    line-height: 24px;
    padding: 0px 20px 0px 24px;
    width: 100%;
    color: white;
    /* background-color: rgba(0, 0, 0, 0.3); */
    position: relative;
    top: 10px;
}
.barre-header hr {
    position: absolute;
    display: inline-block;
}
.barre1 {
    height: 12px;
    width: 3px;
    right: 93px;
    background-color: rgba(255, 255, 255, 0.6);
    color: rgba(255, 255, 255, 0.6);
    border: none;
    bottom: -1px;
}
.barre2 {
    height: 9px;
    width: 3px;
    right: 98px;
    background-color: white;
    border: none;
    bottom: -1px;
}
.barre3 {
    height: 6px;
    width: 3px;
    right: 103px;
    background-color: white;
    border: none;
    bottom: -1px;
}
.barre4 {
    height: 3px;
    width: 3px;
    right: 108px;
    background-color: white;
    border: none;
    bottom: -1px;
}


.batterie1 {
    height: 10px;
    width: 7px;
    right: 78px;
    background-color: rgb(255, 255, 255);
    color: rgb(255, 255, 255);
    border-radius: 0.5px;
    border: none;
    bottom: -1px;
}
.batterie2 {
    height: 13px;
    width: 5px;
    right: 79px;
    bottom: 0px;
    background-color: rgba(255, 255, 255, 0.6);
    border: 0.5px solid white;
    border-radius: 1px;
}

img[alt="img_airplane"] {
    filter: brightness(0) invert(1);
    position: absolute;
    top: 5px;
    bottom: 0;
    margin: auto;
    right: 60px;
}

img[alt="img_battery"] {
    position: absolute;
    top: 5px;
    bottom: 0;
    margin: auto;
    right: 20px;
}

img[alt="img_4g"] {
    position: absolute;
    top: 5px;
    bottom: 0;
    margin: auto;
    right: 76px;
}

img[alt="img_wifi"] {
    position: absolute;
    top: 5px;
    bottom: 0;
    margin: auto;
    right: 50px;
}

</style>
