<script>
import { Bar, mixins } from 'vue-chartjs';
const { reactiveProp } = mixins

export default {
  extends: Bar,
  mixins: [reactiveProp],
  props: ['chartData'],
  name: 'chart',
  data () {
    return {
      data: {
        labels: ['18時', '19時', '20時', '21時', '22時', '23時'],
        datasets: [
          {
            label: 'Bar Dataset',
            data: this.chartData,
            backgroundColor: 
              'rgba(255, 99, 132, 0.2)',
            borderColor: 
              'rgba(255, 99, 132, 1)',
            borderWidth: 1
          },
          {
            label: 'Line Dataset',
            data: [30, 50, 70, 100, 120, 150],
            borderColor: '#CFD8DC',
            fill: false,
            type: 'line',
            lineTension: 0.3,
          }
        ]
      },
      options: {
        scales: {
          xAxes: [{
            scaleLabel: {
              display: true,
              labelString: '予約時間'
            }
          }],
          yAxes: [{
            ticks: {
              beginAtZero: true,
              stepSize: 10,
            }
          }]
        }
      }
    }
  },
  mounted () {
    this.renderChart(this.data, this.options)
  }
}
</script>