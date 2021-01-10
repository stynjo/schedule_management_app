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
      <th scope="row">1</th>
      <td>{{ resereve.reserve_name }}</td>
      <td>{{ resereve.number_of_people }}</td>
      <td>{{ resereve.reservation_start_time }}</td>
      <td>{{ resereve.reservation_end_time }}</td>
    </tr>
  </tbody>
</table>

</template>
<script>
export default {
  props: ['reserve_list'],
  data() {
    return {
    }
  },
  watch: {
    reserve_list: function (val) {
      console.log(this.reserve_list)
    }
  }
}
</script>