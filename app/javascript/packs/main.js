import Vue from 'vue'
import App from '../app.vue'

import VCalendar from 'v-calendar';
Vue.use(VCalendar) 

 new Vue({
   el: '#app',
   render: h => h(App)
})
