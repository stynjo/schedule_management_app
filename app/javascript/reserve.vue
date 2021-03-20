<template>
  <div id="reserve">
    <table class="table table-bordered">
      <thead class="thead-dark">
        <tr>
          <th colspan="2"><h5>予約ページ</h5></th>
         </tr>
      </thead>
      <tbody>
        <tr>
          <td class="text-center w-50">
             <button type="button" class="btn btn-info btn-lg" data-toggle="modal" data-target="#reserve-modal">予約登録フォーム</button>
          </td>
          <td class="text-center"><h3>{{ displayDate }}</h3></td>
        </tr>
      </tbody>
    </table>
    <flash-message ref="flashMessage"></flash-message>
    <div class="row">
      <div class="col-6">
        <radar-chart class="chart_bar" :chart-data="chartData" :options="options"></radar-chart>
      </div>
      <div class="col-6">
      　<div class="row">
          <div class="col-12">
            <div id="calendar-wrapper">
              <v-calendar
              @dayclick='dayClicked'
              :columns="$screens({ default: 1, lg: 2 })"
              :rows="$screens({ default: 1, lg: 2 })"
              ></v-calendar>
            </div>
          </div>
        </div>
      </div>
    </div>  
    <div class="row ">
      <div class="col-12">
        <table class="table table-striped">
          <thead class="thead-dark">
            <tr>
              <th scope="col">予約名</th>
              <th scope="col">人数</th>
              <th scope="col">開始時間</th>
              <th scope="col">終了時間</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="resereve in reserveList" :key="resereve.id">
              <td>{{ resereve.reserve_name }}</td>
              <td>{{ resereve.number_of_people }}</td>
              <td>{{ formatDate(resereve.reservation_start_time) }}</td>
              <td>{{ formatDate(resereve.reservation_end_time) }}</td>
              <td><button type="button" class="btn btn-danger" data-toggle="modal" data-target="#delete-modal" @click="deleteTarget = resereve.id;">削除</button></td>
            </tr>
          </tbody>
        </table>
        <div v-if="reserveList == false">
          <div class="border" style="padding:150px; text-align: center">
            <h4>データがありません</h4>
          </div>
        </div>
      </div>
    </div>
    <delete-modal deleteTarget = '' @ok="onDeleteReserve(deleteTarget);"></delete-modal>
    <reserve-modal @form="this.inputFormValue($event);"></reserve-modal>
  </div>

</template>

  
<script>
import VueTimepicker from 'vue2-timepicker'
import Chart from 'chart.vue';
import axios from 'axios';
import DeleteModal from 'reserve-delete-modal.vue'
import ReserveModal from 'reserve-modal.vue'
import FlashMessage from 'flash-message.vue'

const token = document.getElementsByName('csrf-token')[0].getAttribute('content')
axios.defaults.headers.common['X-CSRF-Token'] = token

/*global $*/

export default {
  components: {
    'vue-timepicker': VueTimepicker,
    'radar-chart': Chart,
    'delete-modal': DeleteModal,
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
      options: {},
      reserveList: {},
      deleteTarget: '',
      formList: {},
    }
  },
  computed: {
    displayDate: function() {
      if (!this.reservationDate) return ''

      return this.reservationDate.replace(/-0?/g, '/')
    }
  },
  methods: {
    //予約更新処理の成否アラート
    showAlert(message) {
      this.$refs.flashMessage.showFlashMessage(message)
    },
    dayClicked(day) {
      this.reservationDate = day.id
      this.getSchedule()
    },
    getSchedule() {
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
    //予約フォームからデータを受け取る
    onSubmitReserveForm(formValue) {
      this.inputStartTime = formValue.startTime
      this.inputEndTime = formValue.endTime
      this.reserveName = formValue.resereveName
      this.numberOfPeople = formValue.number
      this.reservationEndTime = formValue.reserveDate
      this.createReservation()
    },
    //予約更新
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
         }
         this.getSchedule()
      })
      .catch(error => {
        console.log(error);
          this.showAlert('予約登録に失敗しました。');
          this.closeReserveModal()
      });
    },
    onDeleteReserve(resereveId) {
      axios.delete('/reserves/', {params: {resereveId: resereveId}}).then(res => {        
        console.log(res.data);  
        if  (res.status === 204) {
           this.showAlert('予約データを削除しました。');
        }
        this.getSchedule()
      })
    },
    formatDate(dateStr) {
      return this.formatReserveTime(new Date(dateStr), 'hh:mm')
    },
    //Railsから受け取った予約データから時間だけを取り出す
    formatReserveTime(date, format) {
      format = format.replace(/hh/g, ('0' + date.getHours()).slice(-2));
      format = format.replace(/mm/g, ('0' + date.getMinutes()).slice(-2));
      return format;
    },
    updateChartData(reserveData,emloyeeData) {
      console.log("aaaaa")
      this.chartData = {
        labels: ['18時', '19時', '20時', '21時', '22時', '23時'],
        datasets: [
          {
            label: '人員数',
            data: emloyeeData,
            borderColor: '#FF82B2',
            fill: false,
            type: 'line',
            lineTension: 0.3,
          },
          {
            label: '予約件数',
            data: reserveData,
            backgroundColor:
              '#75A9FF',
            borderColor:
              '#75A9FF',
            borderWidth: 1
          }
        ]
      },
      this.options = {
        responsive: true,
        maintainAspectRatio: false,
        legend: {
          position: "bottom"
        },
        layout: {
          padding: 20
        },
        scales: {
          yAxes: [
            {
              ticks: {
                suggestedMin: 0,
                suggestedMax: 100,
                stepSize: 5
              }
            }
          ]
        }
      }
    }
  },
  mounted() {
    let today = new Date();
    this.reservationDate = `${today.getFullYear()}/${today.getMonth() + 1}/${today.getDate()}`
    this.getSchedule()
  }
}
</script>

