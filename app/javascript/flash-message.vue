<template>
  <div class="success-flash" v-if="!!message">
      {{ message }}
  </div>
</template>

<script>
  export default {
    data() {
      return {
        message: "",
      }
    },
    methods: {
      showFlashMessage(message) {
        this.message = message

        setTimeout((vueObj) => {
          vueObj.message = ''
        } ,3000, this)
      }
    }
  }
</script>

<style scoped>
.success-flash{
  width: 200px;
  height: auto;
  background-color: #00FF99;
}
</style>