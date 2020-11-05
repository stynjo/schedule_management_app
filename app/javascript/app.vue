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
     
    <radar-chart class="chart_bar" :chart-data="chartData"></radar-chart> 
    
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
      reserveData: '',
      chartData: {},
    }
  },
  methods: {
    dayClicked(day) {
      this.reservationDate = day.id
      this.getReservations()
    },
    getReservations() {
      this.timeDisplay = true
      axios.get(`/reserves/`, {
        params: {
          reservationDate: this.reservationDate
        }
      })
      .then(res => {
        console.log(res.data)
        this.updateChartData(res.data)
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
    },
    updateChartData(reserveData) {
      this.chartData = {
        labels: ['18時', '19時', '20時', '21時', '22時', '23時'],
        datasets: [
          {
            label: 'Bar Dataset',
            data: reserveData,
            backgroundColor:
              'rgba(255, 99, 132, 0.2)',
            borderColor:
              'rgba(255, 99, 132, 1)',
            borderWidth: 1
          },
          {
            label: 'Line Dataset',
            data: [30, 50, 70, 100, 120, 150],
            borderColor: '#CFD8DC',
            fill: false,
            type: 'line',
            lineTension: 0.3,
          }
        ]
      }
    }
  },
  components: {
    'vue-timepicker': VueTimepicker,
    'radar-chart': Chart
  },
  mounted() {
    let today = new Date();
    this.reservationDate = `${today.getFullYear()}/${today.getMonth() + 1}/${today.getDate()}`
    this.getReservations()
  }
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