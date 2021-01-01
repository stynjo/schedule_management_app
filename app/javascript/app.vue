<template>
  <div id="app">
    <div id="calendar-wrapper">
      <v-calendar
        @dayclick='dayClicked'
        is-expanded
        class="v-calendar"
      ></v-calendar> 
      {{ reservationDate }}
    </div>
    <p v-if ="timeDisplay">
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
        hide-disabled-minutes></vue-timepicker></br>
        予約人数<input type="number" v-model="numberOfPeople">  名</br>
        <input type="submit" value="slackメッセージを送る" v-on:click="sendMessage"></br>
        <input type="submit" value="登録する" v-on:click="createReservation">
     </p>
        
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
      this.timeDisplay = true
      this.reservationDate = day.id
      this.getReservations()
    },
    sendMessage() {
      axios.get(`/reserves/slack/`, {
          params: { reservationDate: this.reservationDate }})
      .then(res => {
        console.log(res.data);
      });
    },
    getReservations() {
       Promise.all([
        axios.get(`/reserves/`, {
          params: { reservationDate: this.reservationDate }}),
        axios.get(`/attendances/index`, {
          params: { reservationDate: this.reservationDate }})
      ])
      .then(responses => {
        responses.forEach(res => console.log(res.data))
        var reserveData = responses[0].data
        var emloyeeData = responses[1].data
        this.updateChartData(reserveData,emloyeeData)
      })
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
          this.timeDisplay = false
    　　});
    },
    updateChartData(reserveData,emloyeeData) {
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
            data: emloyeeData,
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

.chart_bar {
   width: 820px;
   height: 360px;
} 

#calendar-wrapper {
  width: 50%;
  
}

#calendar-wrapper .vc-container {
  --day-content-height: 100px;
  --day-content-width: 100px;
}

#calendar-wrapper .vc-text-sm {
  font-size: 21px;
}

 
</style>