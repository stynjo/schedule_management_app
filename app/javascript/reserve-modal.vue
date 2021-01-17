<template>
  <transition name="modal">
    <div class="modal-mask">
      <div class="modal-wrapper">
        <div class="modal-container">

          <div class="modal-header">
            <slot name="header">
            </slot>
          </div>

          <div class="modal-body">
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
              hide-disabled-minutes></vue-timepicker></br>
              
            予約名<input type="text" v-model="resereveName">  様
            予約人数<input type="number"  v-model="number">  名</br>
            <input type="submit" value="登録する" @click="submit">
          </div>

          <div class="modal-footer">
            <slot name="footer">
              <button type="button" class="btn btn-outline-secondary" @click="$parent.closeReserveModal()">
                Cancel
              </button>
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
      startTime: '',
      endTime: '',
      resereveName: '',
      number: ''
    }
  },
  methods: {
    submit() {
      this.$parent.onSubmitReserveForm({
        startTime: this.startTime,
        endTime: this.endTime,
        resereveName: this.resereveName,
        number: this.number
      })
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