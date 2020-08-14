<template>
  <div id="app">
   <v-calendar
   @dayclick='dayClicked'></v-calendar> 
    {{ selectedDay }}
  </div>
</template>


<script>
  export default {
    data() {
      return { 
        selectedDay: null
      }
    },
    methods: {
      dayClicked(day) {
        this.selectedDay = day.ariaLabel;
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
