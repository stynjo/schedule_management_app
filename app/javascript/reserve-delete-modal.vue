<template>
  <div class="modal fade" id="delete-modal" tabindex="-1" role="dialog" aria-labelledby="delete-modal-label" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header">
          <slot name="header">
            <i class="bi bi-exclamation-triangle" style="font-size: 1rem;">予約を削除します</i>
          </slot>
        </div>
        <div class="modal-body" style="text-align:center;">
           <h5>本当に削除しますか?</h5>
        </div>
        <div class="modal-footer">
          <slot name="footer">
            <td><button class="btn btn-danger" @click="$emit('ok')" data-dismiss="modal">削除</button></td>
            <td><button class="btn btn-secondary" data-dismiss="modal">キャンセル</button></td>
          </slot>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  methods: {
    submit() {
      this.$parent.onDeleteReserve()
    }
  }
}
</script>

<style scoped>
.modal-content {
  background-color: #EEEEEE;
}



.modal-header {
  color: red;
}


</style>