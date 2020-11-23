<template>
  <div id="attendanece">
    <div id="calendar-wrapper">
      <v-calendar
      @dayclick='dayClicked'>
      </v-calendar>
    </div>
    {{ userList }}
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data(){
    return {
      attendanceDate: '',
      userList: {}
    }
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
        this.userList = res.data
      });
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