<template>
  <transition name="modal">
    <div class="modal-mask">
      <div class="modal-wrapper">
        <div class="modal-container">
          <div class="modal-header">
            <slot name="header">
              予約登録フォーム
            </slot>
          </div>

          <div class="modal-body">
            <div class="row">
              <div class="col-2">
                予約日
              </div>
              <div class="col-10">
                 <v-date-picker
                    :popover="popover"
                    v-model="resereveDate">
                    <template v-slot="{ inputValue, inputEvents }">
                      <input :value="inputValue"  v-on="inputEvents" />
                    </template>
                  </v-date-picker>
              </div>
            </div>
            <div class="row">
              <div class="col-2">
                予約時間
              </div>
              <div class="col-10">
                <vue-timepicker
                  v-model="startTime"
                  :hour-range="[18, 24, [18, 24]]"
                  :minute-range="[0, 30]"
                  hide-disabled-hours
                  hide-disabled-minutes></vue-timepicker>
                ~
                <vue-timepicker
                   v-model="endTime"
                  :hour-range="[18, 24, [18, 24]]"
                  :minute-range="[0, 30]"
                  hide-disabled-hours
                  hide-disabled-minutes></vue-timepicker>
              </div>
            </div>
            <div class="row">
              <div class="col-2"> 
                予約名
              </div>
              <div class="col-10"> 
                <input type="text" v-model="resereveName">  様
              </div>
            </div>
            
            <div class="row">
              <div class="col-2"> 
                予約人数
              </div>
              <div class="col-10"> 
                <input type="number"  v-model="number">  名
              </div>
            </div>
          </div>

          <div class="modal-footer">
            <slot name="footer">
              <td><button class="btn btn-primary" @click="submit">更新</button></td>
              <td><button class="btn btn-secondary" @click="$parent.closeReserveModal()">キャンセル</button></td>
            </slot>
          </div>
        </div>
      </div>
    </div>
  </transition>
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
      resereveDate: null,
      startTime: '',
      endTime: '',
      resereveName: '',
      number: ''
    }
  },
  methods: {
    submit() {
      // if (!this.startTime || !this.endTime) {
      //   alert('時刻を設定してください');
      //   return
      // } else if(this.startTime > this.endTime) {
      //   alert('退勤時間より早い出勤時間は設定できません。');
      //   return
      // }
      this.changeDateFormat(this.resereveDate)
      this.$parent.onSubmitReserveForm({
        startTime: this.startTime,
        endTime: this.endTime,
        resereveName: this.resereveName,
        number: this.number,
        resereveDate: this.resereveDate
      })
    },
    changeDateFormat(day){
      this.resereveDate = `${day.getFullYear()}/${day.getMonth() + 1}/${day.getDate()}`
    }
  }
}
</script>

<style scoped>
.modal-mask {
  position: fixed;
  z-index: 9998;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, .5);
  display: table;
  transition: opacity .3s ease;
}

.modal-wrapper {
  display: table-cell;
  vertical-align: middle;
}

.modal-container {
  width: 800px;
  margin: 0px auto;
  padding: 20px 30px;
  background-color: #fff;
  border-radius: 2px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, .33);
  transition: all .3s ease;
  font-family: Helvetica, Arial, sans-serif;
}

.modal-header h3 {
  margin-top: 0;
  color: #42b983;
}

.modal-body {
  margin: 20px 0;
}

.modal-default-button {
  float: right;
}

/*
 * The following styles are auto-applied to elements with
 * transition="modal" when their visibility is toggled
 * by Vue.js.
 *
 * You can easily play with the modal transition by editing
 * these styles.
 */

.modal-enter {
  opacity: 0;
}

.modal-leave-active {
  opacity: 0;
}

.modal-enter .modal-container,
.modal-leave-active .modal-container {
  -webkit-transform: scale(1.1);
  transform: scale(1.1);
}
</style>