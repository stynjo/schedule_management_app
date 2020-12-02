<template>
  <div id="attendanece">
    <div id="calendar-wrapper">
      <v-calendar
      @dayclick='dayClicked'>
      </v-calendar>
    </div>
    <table class="table">
    <thead>
        <tr>
            <th>No</th>
            <th>名前</th>
            <th>出勤時間</th>
            <th>退勤時間</th>
        </tr>
    </thead>
    <tbody>
        <tr v-for="user in users">
          <th>{{ user.id }}</th>
          <td>{{ user.name  }}</td>
          <td><vue-timepicker
               v-model="startTimeHash[user.id]"
               :hour-range="[18, 24, [18, 24]]"
               :minute-range="[0, 30]"
               hide-disabled-hours
               hide-disabled-minutes>
               </vue-timepicker></td>
          <td><vue-timepicker
               v-model="endTimeHash[user.id]"
               :hour-range="[18, 24, [18, 24]]"
               :minute-range="[0, 30]"
               hide-disabled-hours
               hide-disabled-minutes>
               </vue-timepicker>
          </td>
          <td class="btn btn-primary" @click="createAttendance(user.id)">更新</button></td>
        </tr>
    </tbody>
    </table>
  </div>
      
</template>

<script>
import axios from 'axios';
import VueTimepicker from 'vue2-timepicker';
import 'vue2-timepicker/dist/VueTimepicker.css';

export default {
  data(){
    return {
      attendanceDate: '',
      users: [],
      userId: '',
      startTimeHash: {},
      endTimeHash: {},
    }
  },
  components: {
    'vue-timepicker': VueTimepicker,
  },
   methods: {
    dayClicked(day) {
      this.attendanceDate = day.id
      this.getAlluser()
    },
    getAlluser() {
      axios.get(`/users/`)
      .then(res => {
        console.log(res.data)
        this.users = res.data
      });
    },
    createAttendance(user_id) {
      let startTime = this.startTimeHash[user_id]
      let endTime = this.endTimeHash[user_id]
    }
  }
}

</script>

<style>
  
#calendar-wrapper .vc-container {
  --day-content-height: 100px;
  --day-content-width: 100px;
}

#calendar-wrapper .vc-text-sm {
  font-size: 21px;
}
</style>