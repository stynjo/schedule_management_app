
import Vue from 'vue'
import Attendance from '../attendance.vue'
import VCalendar from 'v-calendar'


Vue.use(VCalendar);

document.addEventListener('turbolinks:load', () => {
  const attendance = new Vue({
    render: h => h(Attendance)
  }).$mount('#attendance');
  console.log(Attendance)
})
