<template>
  <div class="modal fade" id="attendance-modal" tabindex="-1" role="dialog" aria-labelledby="#attendance-modal-label" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header">
          <slot name="header">
            <h3>勤怠登録フォーム</h3>
          </slot>
        </div>

        <div class="modal-body">
          <div class="form-group">
            <div class="row">
              <div class="col-4">
                <h5>出勤日</h5>
              </div>
                <div class="col-8">
                   <v-date-picker
                      :popover="popover"
                      v-model="attendanceDate">
                    </v-date-picker>
                </div>
            </div>
          </div>
          <div class="form-group">
            <div class="row">
              <div class="col-4">
                <h5>出勤時間</h5>
              </div>
              <div class="col-8">
                <vue-timepicker
                  v-model="startTime"
                  :hour-range="[18, 24, [18, 24]]"
                  :minute-range="[0, 30]"
                  hide-disabled-hours
                  hide-disabled-minutes></vue-timepicker>
              </div>
            </div>
          </div>
          <div class="form-group">
            <div class="row">
              <div class="col-4">
                <h5>退勤時間</h5>
              </div>
              <div class="col-8">
                <vue-timepicker
                  v-model="endTime"
                  :hour-range="[18, 24, [18, 24]]"
                  :minute-range="[0, 30]"
                  hide-disabled-hours
                  hide-disabled-minutes></vue-timepicker>
              </div>
            </div>
          </div>
        </div>
        
        <div class="modal-footer">
          <slot name="footer">
            <td><button class="btn btn-primary" @click="submit" data-dismiss="modal">登録</button></td>
            <td><button class="btn btn-secondary" data-dismiss="modal">キャンセル</button></td>
          </slot>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import VueTimepicker from 'vue2-timepicker'
export default {
  components: {
    'vue-timepicker': VueTimepicker
  },
  data() {
    return {
      popover: null,
      attendanceDate: null,
      startTime: '',
      endTime: ''
    }
  },
  methods: {
    submit() {
      if (!this.startTime || !this.endTime) {
        alert('時刻を設定してください');
        return
      } else if(this.startTime > this.endTime) {
        alert('退勤時間より早い出勤時間は設定できません。');
        return
      }
      this.changeDateFormat(this.attendanceDate)
      this.$parent.onSubmitAttendanceForm({
        startTime: this.startTime,
        endTime: this.endTime,
        attendanceDate: this.attendanceDate
      })
    },
    changeDateFormat(day){
      this.attendanceDate = `${day.getFullYear()}/${day.getMonth() + 1}/${day.getDate()}`
    }
  }
}
</script>

<style scoped>
.modal-content  {
  background-color: #EEEEEE;
}

.modal-header {
  border-bottom: 0.5px solid #CCCCCC;
}
.modal-footer {
  border-top: 0.5px solid #CCCCCC;
}


</style>