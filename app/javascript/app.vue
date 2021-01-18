<template>
  <div id="app">

    <flash-message ref="flashMessage"></flash-message>
    
    <div id="calendar-wrapper">
      <v-calendar
      @dayclick='dayClicked'
      is-expanded
      class="v-calendar"
      ></v-calendar> 
      {{ reservationDate }}
    </div>
    <button type="button" class="btn btn-info" @click="openReserveModal()">予約登録フォーム</button>

    <table class="table table-striped">
      <thead>
        <tr>
          <th scope="col">予約名</th>
          <th scope="col">人数</th>
          <th scope="col">開始時間</th>
          <th scope="col">終了時間</th>
       </tr>
     </thead>
     <tbody>
       <tr v-for="resereve in reserveList" :key="resereve.id">
         <td>{{ resereve.reserve_name }}</td>
         <td>{{ resereve.number_of_people }}</td>
         <td>{{ formatDate(resereve.reservation_start_time) }}</td>
         <td>{{ formatDate(resereve.reservation_end_time) }}</td>
         <td><button class="btn btn-danger" @click="deleteTarget = resereve.id; resereveDeleteModal = true">削除</button></td>
       </tr>
     </tbody>
   </table>  
  <radar-chart class="chart_bar" :chart-data="chartData"></radar-chart>
  <modal v-if="resereveDeleteModal" @cancel="resereveDeleteModal = false; deleteTarget = ''" @ok="onDeleteReserve(deleteTarget); resereveDeleteModal = false;"></modal>
  
  <reserve-modal v-if="resereveResponseModal" @cancel="this.resereveResponseModal = false;" @form="this.inputFormValue($event); this.resereveResponseModal = false;"></reserve-modal>
</div>

</template>


<script>
import VueTimepicker from 'vue2-timepicker'
import 'vue2-timepicker/dist/VueTimepicker.css'
import 'bootstrap/dist/css/bootstrap.css' 
import 'bootstrap-vue/dist/bootstrap-vue.css'
import Chart from 'chart.vue';
import axios from 'axios';
import modal from 'delete-modal.vue'
import ReserveModal from 'reserve-modal.vue'
import FlashMessage from 'flash-message.vue'

const token = document.getElementsByName('csrf-token')[0].getAttribute('content')
axios.defaults.headers.common['X-CSRF-Token'] = token

/*global $*/

export default {
  components: {
    'vue-timepicker': VueTimepicker,
    'radar-chart': Chart,
    'modal': modal,
    'reserve-modal': ReserveModal,
    'flash-message': FlashMessage,
  },
  props: ['reserve_times'],
  data() {
    return { 
      reservationDate: null,
      inputStartTime: '',
      inputEndTime: '',
      reservationStartTime: null,
      reservationEndTime: null,
      numberOfPeople: '',
      reserveName:'',
      reserveData: '',
      chartData: {},
      reserveList: {},
      resereveDeleteModal: false,
      deleteTarget: '',
      resereveResponseModal: false,
      formList: {},
    }
  },
  methods: {
    showAlert(message) {
      this.$refs.flashMessage.showFlashMessage(message)
    },
    openReserveModal() {
      this.resereveResponseModal = true
    },
    closeReserveModal() {
      this.resereveResponseModal = false
    },
    dayClicked(day) {
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
    onSubmitReserveForm(formValue) {
      this.inputStartTime = formValue.startTime
      this.inputEndTime = formValue.endTime
      this.reserveName = formValue.resereveName
      this.numberOfPeople = formValue.number
      this.reservationEndTime = formValue.reserveDate
      this.createReservation()
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
            this.showAlert('予約登録を完了しました。');
          } else if (res.status === 422) {
            this.showAlert('予約登録に失敗しました。');
          }
          this.closeReserveModal()
    　　});
    },
    onDeleteReserve(resereveId) {
      axios.delete('/reserves/', {params: {resereveId: resereveId}}).then(res => {        
        console.log(res.data);  
        if  (res.status === 204) {
           this.showAlert('予約データを削除しました。');
        }
      })
    },
    formatDate(dateStr) {
      return this.dateToStr24HPad0DayOfWeek(new Date(dateStr), 'hh:mm')
    },
    dateToStr24HPad0DayOfWeek(date, format) {
      var weekday = ["日", "月", "火", "水", "木", "金", "土"];
      if (!format) {
          format = 'YYYY/MM/DD(WW) hh:mm:ss'
      }
      format = format.replace(/YYYY/g, date.getFullYear());
      format = format.replace(/MM/g, ('0' + (date.getMonth() + 1)).slice(-2));
      format = format.replace(/DD/g, ('0' + date.getDate()).slice(-2));
      format = format.replace(/WW/g, weekday[date.getDay()]);
      format = format.replace(/hh/g, ('0' + date.getHours()).slice(-2));
      format = format.replace(/mm/g, ('0' + date.getMinutes()).slice(-2));
      format = format.replace(/ss/g, ('0' + date.getSeconds()).slice(-2));
      return format;
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