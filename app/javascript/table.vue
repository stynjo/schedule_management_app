<template>
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
     <tr v-for="resereve in reserve_list" :key="resereve.id">
      <td>{{ resereve.reserve_name }}</td>
      <td>{{ resereve.number_of_people }}</td>
      <td>{{ resereve.reservation_start_time }}</td>
      <td>{{ resereve.reservation_end_time }}</td>
      <td class="btn btn-danger" @click="onDeleteReserve(resereve.id)">削除</button></td>
    </tr>
  </tbody>
</table>

</template>
<script>

import axios from 'axios';

export default {
  props: ['reserve_list'],
  data() {
    return {
    }
  },
  methods: {
    onDeleteReserve(resereveId) {
      axios.delete('/reserves/', {params: {resereveId: resereveId}}).then(res => {        
        console.log(res.data);  
        if  (res.status === 204) {
           alert('予約データを削除しました。');
        }
      })
    }
  },
  watch: {
    reserve_list: function (val) {
      console.log(this.reserve_list)
    }
  }
}
</script>