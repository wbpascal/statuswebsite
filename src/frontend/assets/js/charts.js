import Chart from 'chart.js';
import moment from 'moment-timezone';

export function buildChartFromMeasurements(canvas, measurements) {
    var ctx = canvas.getContext('2d');
    console.log(moment.tz.guess())
    var data = measurements.map(function (measurement) {
       return {
           t: moment.unix(measurement.endTime).utc().tz(moment.tz.guess()),
           y: measurement.responseTime
       }
    });
    var chart = new Chart(ctx, {
        // The type of chart we want to create
        type: 'line',

        // The data for our dataset
        data: {
            datasets: [{
                label: "Response Time",
                borderColor: 'rgb(51, 153, 255)',
                fill: false,
                data: data,
            }]
        },

        // Configuration options go here
        options: {
            spanGaps: false,
            elements: {
                line: {
                    tension: 0, // disables bezier curves
                }
            },
            scales: {
                xAxes: [{
                    type: 'time',
                    distribution: 'linear',
                    time: {
                        unit: 'minute',
                        displayFormats: {
                            'minute': 'HH:mm',
                            'hour': 'HH:mm'
                        },
                        tooltipFormat: 'H:mm:ss'
                    }
                }]
            }
        }
    });
}

window.buildChartFromMeasurements = buildChartFromMeasurements;