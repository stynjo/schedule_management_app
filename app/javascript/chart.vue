<script>
import { Bar, mixins } from 'vue-chartjs';
const { reactiveProp } = mixins

export default {
  extends: Bar,
  mixins: [reactiveProp],
  name: 'chart',
  mounted () {
    this.renderChart(this.chartData, this.options)
  }
}
</script>