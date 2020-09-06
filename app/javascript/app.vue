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
    <p><input type="submit" value="登録する" v-on:click="createReservation"></p>
  </div>
</template>


<script>
import VueTimepicker from 'vue2-timepicker'
import 'vue2-timepicker/dist/VueTimepicker.css'
import axios from 'axios';

export default {
  data() {
    return { 
      reservationDate: null,
      inputStartTime: '',
      inputEndTime: '',
      timeDisplay: false,
      reservationStartTime: null,
      reservationEndTime: null
    }
  },
  methods: {
    dayClicked(day) {
      this.reservationDate = day.id
      this.timeDisplay = true
    },
    createReservation() {
      let fromDate = new Date(`${this.reservationDate} ${this.inputStartTime}`)
      this.reservationStartTime = fromDate.getTime();
      let toDate = new Date(`${this.reservationDate} ${this.inputEndTime}`)
       this.reservationEndTime = toDate.getTime();
      axios.post(`/reserves/`, {reservation_date: this.reservationDate, reservation_start_time: this.reservationStartTime, reservation_end_time: this.reservationEndTime})
       .then(res => {
          console.log(res.data);
    　　});
    }
  },
  components: {
    'vue-timepicker': VueTimepicker,
  }
}
</script>

<style>
#app {
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
