<template>
<table class="table table-striped">
     <modal></modal>
  <thead>
    <tr>
      <th scope="col">予約名</th>
      <th scope="col">人数</th>
      <th scope="col">開始時間</th>
      <th scope="col">終了時間</th>
    </tr>
  </thead>
  <tbody>
    <tr v-for="resereve in reserve_list" :key="resereve.id">
      <td>{{ resereve.reserve_name }}</td>
      <td>{{ resereve.number_of_people }}</td>
      <td>{{ formatDate(resereve.reservation_start_time) }}</td>
      <td>{{ formatDate(resereve.reservation_end_time) }}</td>
      <td class="btn btn-danger" @click="showModal(resereve.id)">削除</button></td>
    </tr>
  </tbody>
</table>
</template>
<script>
import modal from 'modal.vue'
import axios from 'axios';

export default {
  components: {
    'modal': modal
  },
  props: ['reserve_list'],
  data() {
    return {
      modalAlert: false,
      resereveId: ''
    }
  },
  methods: {
    showModal(resereveId) {
      this.modalAlert = true
      this.resereveId = resereveId
    },
    onDeleteReserve(resereveId) {
      axios.delete('/reserves/', {params: {resereveId: resereveId}}).then(res => {        
        console.log(res.data);  
        if  (res.status === 204) {
           alert('予約データを削除しました。');
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
    }
  },
  watch: {
    reserve_list: function (val) {
      console.log(this.reserve_list)
    }
  }
}
</script>