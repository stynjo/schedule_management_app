
import Vue from 'vue'
import Attendance from '../attendance.vue'
import VCalendar from 'v-calendar'

import BootstrapVue from 'bootstrap-vue'

import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'

Vue.use(BootstrapVue)
Vue.use(VCalendar);

document.addEventListener('turbolinks:load', () => {
  const attendance = new Vue({
    render: h => h(Attendance)
  }).$mount('#attendance');
  console.log(Attendance)
})
