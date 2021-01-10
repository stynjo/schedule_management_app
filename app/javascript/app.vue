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
     <reserve-table :reserve_list="reserveList"></reserve-table>
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
        予約名<input type="text" v-model="reserveName">  様
        予約人数<input type="number" v-model="numberOfPeople">  名</br>
        <input type="submit" value="登録する" v-on:click="createReservation">
     </p>
      
    <radar-chart class="chart_bar" :chart-data="chartData"></radar-chart> 
    
  </div>
 
</template>


<script>
import VueTimepicker from 'vue2-timepicker'
import 'vue2-timepicker/dist/VueTimepicker.css'
import 'bootstrap/dist/css/bootstrap.css' 
import 'bootstrap-vue/dist/bootstrap-vue.css'
import Chart from 'chart.vue';
import axios from 'axios';
import Table from 'table.vue';

const token = document.getElementsByName('csrf-token')[0].getAttribute('content')
axios.defaults.headers.common['X-CSRF-Token'] = token

/*global $*/

export default {
  components: {
    'vue-timepicker': VueTimepicker,
    'radar-chart': Chart,
    'reserve-table': Table
  },
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
      reserveName:'',
      reserveData: '',
      chartData: {},
      reserveList: {}
    }
  },
  methods: {
    dayClicked(day) {
      this.timeDisplay = true
      this.reservationDate = day.id
      this.getReservations()
    },
    getReservations() {
       Promise.all([
         //時間あたりの予約数取得
        axios.get(`/reserves/index`, {
          params: { reservationDate: this.reservationDate }}),
         //時間あたりの人員数取得
        axios.get(`/attendances/index`, {
          params: { reservationDate: this.reservationDate }}),
          //その日の予約データ取得
        axios.get(`/reserves/date`, {
          params: { reservationDate: this.reservationDate }})
      ])
      .then(responses => {
        responses.forEach(res => console.log(res.data))
        var reserveData = responses[0].data
        var emloyeeData = responses[1].data
        this.updateChartData(reserveData,emloyeeData)

        this.reserveList = responses[2].data
      })
    },
    createReservation() {
      this.reservationStartTime = (`${this.reservationDate} ${this.inputStartTime}`)
      this.reservationEndTime = (`${this.reservationDate} ${this.inputEndTime}`)
      axios.post(`/reserves/`, { reservation_date: this.reservationDate,
                                 reservation_start_time: this.reservationStartTime,
                                 reservation_end_time: this.reservationEndTime,
                                 number_of_people: this.numberOfPeople,
                                 reserve_name: this.reserveName
                               })
       .then(res => {
          console.log(res.data);
          if  (res.status === 201) {
           alert('予約登録を完了しました。');
          } else if (res.status === 422) {
            alert('予約登録に失敗しました。');
          }
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