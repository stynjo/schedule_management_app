<template>
  <div v-if="!!message">
    <div class="alert alert-light" role="alert">
      {{ message }}
    </div>
  </div>
</template>

<script>
  export default {
    data() {
      return {
        message: ""
      }
    },
    methods: {
      showFlashMessage(message, type) {
        this.message = message
        this.type = type
        setTimeout((vueObj) => {
          vueObj.message = ''
        } ,3000, this)
      }
    }
  }
</script>

<style scoped>
/*.success-flash{*/
/*  width: 200px;*/
/*  height: auto;*/
/*}*/
</style>