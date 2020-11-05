<template>
  <div id="app">
   <v-calendar
   @dayclick='dayClicked'></v-calendar> 
    {{ reservationDate }}
    <p v-if="timeDisplay == true">

      <vue-timepicker
        v-model="inputStartTime"
        :hour-range="[18, 24, [18, 24]]"
        :minute-range="[0, 30]"
        hide-disabled-hours
        hide-disabled-minutes></vue-timepicker>
      ~
      <vue-timepicker
        v-model="inputEndTime"
        :hour-range="[18, 24, [18, 24]]"
        :minute-range="[0, 30]"
        hide-disabled-hours
        hide-disabled-minutes></vue-timepicker></p>
        <p>予約人数<input type="number" v-model="numberOfPeople">  名</p>
    <p><input type="submit" value="登録する" v-on:click="createReservation"></p>
     
    <radar-chart class="chart_bar" :chart_data="getReserveData"></radar-chart> 
    
  </div>
 
</template>


<script>
import VueTimepicker from 'vue2-timepicker'
import 'vue2-timepicker/dist/VueTimepicker.css'
import Chart from 'chart.vue';
import axios from 'axios';

const token = document.getElementsByName('csrf-token')[0].getAttribute('content')
axios.defaults.headers.common['X-CSRF-Token'] = token

/*global $*/

export default {
  props: ['reserve_times'],
  data() {
    return { 
      reservationDate: null,
      inputStartTime: '',
      inputEndTime: '',
      timeDisplay: false,
      reservationStartTime: null,
      reservationEndTime: null,
      numberOfPeople: '',
      getReserveData: ''
    }
  },
  methods: {
    dayClicked(day) {
      this.reservationDate = day.id
      this.timeDisplay = true
      axios.get(`/reserves/`, {
        params: {
          reservationDate: this.reservationDate
        }
      })
      .then(res => {
        console.log(res.data)
        this.getReserveData = res.data
      });
      
    },
    createReservation() {
      this.reservationStartTime = (`${this.reservationDate} ${this.inputStartTime}`)
      this.reservationEndTime = (`${this.reservationDate} ${this.inputEndTime}`)
      axios.post(`/reserves/`, { reservation_date: this.reservationDate,
                                 reservation_start_time: this.reservationStartTime,
                                 reservation_end_time: this.reservationEndTime,
                                 number_of_people: this.numberOfPeople
                               })
       .then(res => {
          console.log(res.data);
    　　});
    }
  },
  components: {
    'vue-timepicker': VueTimepicker,
    'radar-chart': Chart
  },
}
</script>

<style>
#app {
}
.v-calendar {
   width: 820px;
   height: 360px;
}
.chart_bar {
  margin: 180px;
} 
</style>