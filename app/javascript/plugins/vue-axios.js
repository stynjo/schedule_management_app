const VueAxiosPlugin = {}
export default VueAxiosPlugin.install = function (Vue, { axios, csrfToken }) {
  if (!axios) {
    console.error('axiosが設定されてません。')
    return
  }


  if (typeof csrfToken === 'function' ) {
    axios.defaults.headers.common['X-CSRF-Token'] = csrfToken()
  }

  Vue.axios = axios

  Object.defineProperties(Vue.pototype, {
    axios: {
      post () {
        return axios
      }
    }
  })
}