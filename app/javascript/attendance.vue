<template>
  <div id="attendanece">
    <flash-message ref="flashMessage"></flash-message>
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
                  <td><button class="btn btn-primary" @click="onCreateAttendance(user.id)">更新</button></td>
                  <td><button type="button" class="btn btn-danger" data-toggle="modal" data-target="#attendance-delete-modal" @click="deleteTarget = user.id;">削除</button></td>
                </tr>
              </tbody>
            </table>
          </div>
            <div class="csv">
              <input type="file" @change="loadCsvFile" /></br>
              {{ message }}
            </div>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <table class="table table-bordered">
          <thead class="thead-dark">
            <tr>
              <th>No</th>
              <th>名前</th>
              <th>出勤時間 / 選択日{{ attendanceDate }}</th>
              <th>退勤時間</th>
              <th></th>
              <th></th>
            </tr>
          </thead>
          <tbody class="user-list">
            <tr v-for="user in users" :key="user.id">
              <th>{{ user.id }}</th>
              <td>{{ user.name  }}</td>
              <td><vue-timepicker
                v-model="startTimeHash[user.id]"
                :hour-range="[18, 24, [18, 24]]"
                :minute-range="[0, 30]"
                hide-disabled-hours
                hide-disabled-minutes
                ref="startTime">
              </vue-timepicker></td>
              <td><vue-timepicker
                v-model="endTimeHash[user.id]"
                :hour-range="[18, 24, [18, 24]]"
                :minute-range="[0, 30]"
                hide-disabled-hours
                hide-disabled-minutes
                ref="endTime">
              </vue-timepicker></td>
              <td><button class="btn btn-primary" @click="onCreateAttendance(user.id)">更新</button></td>
              <td><button type="button" class="btn btn-danger" data-toggle="modal" data-target="#attendance-delete-modal" @click="deleteTarget = user.id;">削除</button></td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
    <attendance-delete-modal deleteTarget = '' @ok="onDeleteAttendance(deleteTarget);"></attendance-delete-modal>
  </div>
</template>

<script>
import axios from 'axios';
import Chart from 'chart.vue';
import VueTimepicker from 'vue2-timepicker';
import FlashMessage from 'flash-message.vue'
import DeleteModal from 'delete-modal.vue'
import AttendanceDeleteModal from 'attendance-delete-modal.vue'

const token = document.getElementsByName('csrf-token')[0].getAttribute('content')
axios.defaults.headers.common['X-CSRF-Token'] = token
export default {
  data(){
    return {
      attendanceDate: '',
      attendanceIdHash: {},
      attendanceTargerTimes: [],
      users: [],
      userId: '',
      startTimeHash: {},
      endTimeHash: {},
      message: "",
      uploadFile: null,
      attendanceDeleteModal: false,
      deleteTarget: '',
      flashMessage: '',
      attendanceListStart: [],
      attendanceListEnd: [],
      chartData: {},
      options: {}
    }
  },
  components: {
    'vue-timepicker': VueTimepicker,
    'delete-modal': DeleteModal,
    'attendance-delete-modal': AttendanceDeleteModal,
    'radar-chart': Chart,
    'flash-message': FlashMessage
  },
  computed: {
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
      this.getReservations();
    },
    getReservations() {
       Promise.all([
         //時間あたりの予約数取得
        axios.get(`/reserves/index`, {
          params: { reservationDate: this.attendanceDate }}),
         //時間あたりの人員数取得
        axios.get(`/attendances/index`, {
          params: { reservationDate: this.attendanceDate }}),
          //その日の予約データ取得
        axios.get(`/reserves/date`, {
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
    onCreateAttendance(userId) {
      let startTime = this.startTimeHash[userId];
      let endTime = this.endTimeHash[userId];
      if (startTime instanceof Object) { startTime = `${startTime.HH}:${startTime.mm}` }
      if (endTime instanceof Object) { endTime = `${endTime.HH}:${endTime.mm}` }
      if (!startTime || !endTime) {
        alert('時刻を設定してください');
        return
      } else if(startTime > endTime) {
        alert('退勤時間より早い出勤時間は設定できません。');
        return
      }
      let startTimeStr = `${this.attendanceDate} ${startTime}`
      let endTimeStr = `${this.attendanceDate} ${endTime}`
      // 問題なければAPI叩いて勤怠登録する
      this.updateAttendance(userId, startTimeStr, endTimeStr)
    },
    onDeleteAttendance(userId) {
      let startTime = this.startTimeHash[userId];
      let endTime = this.endTimeHash[userId];
      if (!startTime || !endTime) {
        alert('日付を設定してください');
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
      this.$refs.startTime.forEach(e => {e.clearTime()})
      this.$refs.endTime.forEach(e => { e.clearTime() })
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
      });
    },
    updateAttendance(userId, startTime, endTime) {
      let httpMethod = 'post';
      let params = {
        attendance: {
          user_id: userId,
          started_at: startTime,
          finished_at: endTime,
        }
      };
      
      if (this.attendanceIdHash[userId]) {
        // attendanceIdが存在する = 更新処理とする
        httpMethod = 'put';
      }
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
    showAlert(message) {
      this.$refs.flashMessage.showFlashMessage(message)
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