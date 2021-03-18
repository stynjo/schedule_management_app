<template>
  <div id="attendanece">
    <table class="table table-bordered">
      <thead class="thead-dark">
        <tr>
          <th colspan="2"><h5>勤怠編集ページ</h5></th>
         </tr>
      </thead>
      <tbody>
        <tr>
          <td class="text-center w-75">
             <h5>一括勤怠登録 : <input type="file" @change="loadCsvFile" /></h5>
             {{ csvMessage }}
          </td>
          <td class="text-center"><h3>{{ displayDate }}</h3></td>
        </tr>
      </tbody>
    </table>
    <div class="row">
      <div class="col-12">
        <flash-message ref="flashMessage"></flash-message>
      </div>
    </div>
    <div class="row">
      <div class="col-6">
        <radar-chart class="chart_bar" :chart-data="chartData" :options="options"></radar-chart>
      </div>
      <div class="col-6">
        <div class="row">
          <div class="col-12">
            <div id="calendar-wrapper">
              <div class="d-flex flex-column">
                <v-calendar
                :columns="$screens({ default: 1, lg: 2 })"
                :rows="$screens({ default: 1, lg: 2 })"
                @dayclick='dayClicked'>
                </v-calendar>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <div id="attendance-table">
          <div class="table-responsive">
            <table class="table table-sm table-bordered">
              <thead class="thead-dark">
                <tr>
                  <th>名前</th>
                  <th v-for="targetTime in attendanceTargerTimes">{{ targetTime }}</th>
                  <th></th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="user in users" :key="user.id">
                  <td>{{ user.name  }}</td>
                  <td v-for="targetTime in attendanceTargerTimes" class="attend" :class="getAttendanceCssClass(user, targetTime)">
                    <div class="chart">&nbsp;</div>
                  </td>
                  <td><button type="button" class="btn btn-primary" data-toggle="modal" data-target="#attendance-modal" @click="registrationTarget = user.id;">登録</button></td>
                  <td><button type="button" class="btn btn-danger" data-toggle="modal" data-target="#attendance-delete-modal" @click="deleteTarget = user.id;">削除</button></td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
    <attendance-modal :createAttendanceDate='displayDate' deleteTarget='' @ok="onCreateAttendance(deleteTarget);"></attendance-modal>
    <attendance-delete-modal deleteTarget='' @ok="onDeleteAttendance(deleteTarget);"></attendance-delete-modal>
  </div>

</template>

<script>
import axios from 'axios'
import Chart from 'chart.vue'
import VueTimepicker from 'vue2-timepicker'
import FlashMessage from 'flash-message.vue'
import DeleteModal from 'delete-modal.vue'
import AttendanceModal from 'attendance-modal.vue'
import AttendanceDeleteModal from 'attendance-delete-modal.vue'

const token = document.getElementsByName('csrf-token')[0].getAttribute('content')
axios.defaults.headers.common['X-CSRF-Token'] = token
export default {
  data(){
    return {
      users: [],
      userId: '',
      attendanceDate: '',
      attendanceIdHash: {},
      attendanceTargerTimes: [],
      startTimeHash: {},
      endTimeHash: {},
      csvMessage: "",
      uploadFile: null,
      deleteTarget: '',
      attendanceDeleteModal: false,
      registrationTarget: '',
      attendanceListStart: [],
      attendanceListEnd: [],
      chartData: {},
      options: {},
      flashMessage: '',
    }
  },
  components: {
    'vue-timepicker': VueTimepicker,
    'delete-modal': DeleteModal,
    'attendance-modal': AttendanceModal,
    'attendance-delete-modal': AttendanceDeleteModal,
    'radar-chart': Chart,
    'flash-message': FlashMessage
  },
  computed: {
    displayDate: function() {
      if (!this.attendanceDate) return ''
      return this.attendanceDate.replace(/-0?/g, '/')
    },
    getAttendanceCssClass() {
      return function(user, targetTime) {
        const startTime = this.startTimeHash[user.id]
        const endTime = this.endTimeHash[user.id]

        if (!startTime) return
        if (!endTime) return

        const attended = (startTime <= targetTime && targetTime < endTime)
        return attended ? 'attended' : ''
      }
    }
  },
  methods: {
    dayClicked(day) {
      this.attendanceDate = day.id;
      // 選択された日付の内容で勤怠一覧を更新する
      this.updateAttendancesByDate();
      this.getSchedule();
    },
    getSchedule() {
       Promise.all([
         //時間あたりの予約数取得
        axios.get(`/reserves/index`, {
          params: { reservationDate: this.attendanceDate }}),
         //時間あたりの人員数取得
        axios.get(`/attendances/index`, {
          params: { reservationDate: this.attendanceDate }})
      ])
      .then(responses => {
        responses.forEach(res => console.log(res.data));
        var reserveData = responses[0].data;
        var emloyeeData = responses[1].data;
        this.updateChartData(reserveData,emloyeeData);
      });
    },
    loadCsvFile: function(e) {
      e.preventDefault();
      let files = e.target.files;
      this.uploadFile = files[0];

      if (!this.uploadFile.type.match("text/csv")) {
        this.message = "CSVファイルを選択してください";
        return;
      }

      let formData = new FormData();
      formData.append('file', this.uploadFile);
      this.message = '';

      axios
      .post(`/attendances/import/`, formData)
      .then(res => {
        console.log(res.data);
        if (res.data === true) {
          this.showAlert('勤怠登録が完了しました。')
        }
      })
      .catch(error => {
        console.log(error);
        if (error === error) {
          this.showAlert('勤怠登録に失敗しました。')
        }
      });
    },
    onCreateAttendance(formValue) {
      let startTime = formValue.startTime;
      let endTime = formValue.endTime;
      if (startTime instanceof Object) { startTime = `${startTime.HH}:${startTime.mm}` }
      if (endTime instanceof Object) { endTime = `${endTime.HH}:${endTime.mm}` }

      let startTimeStr = `${this.attendanceDate} ${startTime}`
      let endTimeStr = `${this.attendanceDate} ${endTime}`
      
  
      this.updateAttendance(this.registrationTarget, startTimeStr, endTimeStr)
    },
    onDeleteAttendance(userId) {
      let startTime = this.startTimeHash[userId];
      let endTime = this.endTimeHash[userId];
      if (!startTime || !endTime) {
        alert('勤怠情報がありません。');
        this.deleteTarget = ''
        return
      }
      let attendanceId = this.attendanceIdHash[userId]
      axios.delete('/attendances/', {params: {attendanceId: attendanceId}}).then(res => {        
        console.log(res.data);  
        if (res.status === 204) {
          this.showAlert('勤怠登録を削除しました。')
        }
        this.updateAttendancesByDate();
      })
    },
    updateAttendancesByDate() {
      let startTimeHash = {}
      let endTimeHash = {}
      let attendanceIdHash = {}
      
      // vue-timepickerをリセット
      // this.$refs.startTime.forEach(e => {e.clearTime()})
      // this.$refs.endTime.forEach(e => { e.clearTime() })
      
      // 入力済みの勤怠情報を取得してthis.startTimeHash/endTimeHashの内容を更新する
      axios.get(`/attendances/date/${this.attendanceDate}`)
      .then(res => {
        console.log(res.data);
        res.data.forEach(attendance => {
          let userId = attendance.user_id;
          attendanceIdHash[userId] = attendance.id;
          startTimeHash[userId] = this.timeStringByDatetimeStr(attendance.started_at);
          endTimeHash[userId] = this.timeStringByDatetimeStr(attendance.finished_at);
        });
        this.startTimeHash = startTimeHash;
        this.endTimeHash = endTimeHash;
        this.attendanceIdHash = attendanceIdHash;
        this.getSchedule();
      });
    },
    updateAttendance(userId, startTime, endTime) {
      let httpMethod = 'post';
      let params = {
        attendance: {
          user_id: userId,
          started_at: startTime,
          finished_at: endTime,
          worked_on: this.attendanceDate
        }
      };

      axios.request({
        method: httpMethod,
        url: '/attendances/',
        data: params,
      })
      .then(res => {
       console.log(res.data);
         if  (res.status === 201) {
           this.showAlert('勤怠登録を完了しました。');
         }
        this.updateAttendancesByDate();
      })
      .catch(error => {
        console.log(error);
          this.showAlert('勤怠登録に失敗しました。');
      });
    },
    getAlluser() {
      axios.get(`/users/`)
      .then(res => {
        console.log(res.data);
        this.users = res.data;
      });
    },
    timeStringByDatetimeStr(src) {
      let datetime = new Date(src);
      let zeroPadding = (src, digit) => {
        return ("0".repeat(digit) + src).slice(-1 * digit);
      };
      return `${zeroPadding(datetime.getHours(), 2)}:${zeroPadding(datetime.getMinutes(), 2)}`;
    },
    showAlert(message, type) {
      this.$refs.flashMessage.showFlashMessage(message, type)
    },
    updateChartData(reserveData,emloyeeData) {
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
  mounted: function () {
    this.getAlluser();
    let today = new Date();
    this.attendanceDate = `${today.getFullYear()}-${today.getMonth() + 1}-${today.getDate()}`
    this.getSchedule();
    this.updateAttendancesByDate()

    // 勤怠時刻の一覧を用意する
    const vueObj = this

    for (var hour = 18; hour <= 24; hour++) {
      ['00', '30'].forEach(minute => {
        vueObj.attendanceTargerTimes.push(`${hour}:${minute}`)
      })
    }
    console.log('aaa')
  }
};
</script>

<style>

/*#calendar-wrapper .vc-container {*/
/*  --day-content-height: 90px;*/
/*  --day-content-width: 150px;*/
/*}*/
/*#calendar-wrapper .vc-text-sm {*/
/*  font-size: 21px;*/
/*}*/

#attendance-table td.attend {
  padding: 12px 0;
}
#attendance-table td.attend.attended .chart {
  background-color: #fc693b;
  background-image:
    repeating-linear-gradient(-45deg,#fff, #fff 7px,transparent 0, transparent 11px);
}
</style>