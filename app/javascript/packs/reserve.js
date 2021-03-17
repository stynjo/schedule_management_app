
import Vue from 'vue'
import Reserve from '../reserve.vue'


import BootstrapVue from 'bootstrap-vue'
import VCalendar from 'v-calendar'

Vue.use(BootstrapVue)
Vue.use(VCalendar);


document.addEventListener('turbolinks:load', () => {
  const reserve = new Vue({
    render: h => h(Reserve)
  }).$mount('#reserve');
  console.log(Reserve)
})
