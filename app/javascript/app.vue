<template>
  <div id="app">
   <v-calendar
   @dayclick='dayClicked'></v-calendar> 
    {{ reservation_date }}
  </div>
</template>


<script>
  export default {
    data() {
      return { 
        reservation_date: null,
        resavation_time: ''
      }
    },
    methods: {
      dayClicked(day) {
        this.reservation_date = day
      }
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
