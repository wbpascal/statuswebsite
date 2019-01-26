import Chart from 'chart.js';
import moment from 'moment-timezone';
import socket from "./socket";

function buildChartFromMeasurements(canvas, measurements) {
    let ctx = canvas.getContext('2d');
    return new Chart(ctx, {
        // The type of chart we want to create
        type: 'line',

        // The data for our dataset
        data: {
            datasets: [{
                label: "Response Time",
                borderColor: 'rgb(51, 153, 255)',
                fill: false,
                data: measurements,
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

export function createService(id, chartCanvas, statusContainer, measurements) {
    let data = measurements.map(function (measurement) {
        return {
            t: moment.unix(measurement.endTime).utc().tz(moment.tz.guess()),
            y: measurement.responseTime
        }
    });

    return new Service(id, chartCanvas, statusContainer, data);
}

export class Service {
    constructor(id, chartCanvas, statusContainer, measurements) {
        this.id = id;
        this.statusContainer = statusContainer;
        this.measurements = measurements;
        this.chart = buildChartFromMeasurements(chartCanvas, this.measurements);
    }

    get status() {
        // if() //last element of measurements online
    }

    addNewMeasurement(timeTaken, timestamp) {
        let data = {
            t: moment.unix(timestamp).utc().tz(moment.tz.guess()), // Convert timestamp to local time of user
            y: timeTaken
        };
        this.measurements.push(data);
        this.updateChart();
    }

    startListeningForUpdates() {
        let channel = socket.channel("measurements:" + this.id, {});
        channel.join()
            .receive("ok", resp => { console.log("Joined successfully channel with topic measurements:" + this.id, resp) })
            .receive("error", resp => { console.log("Unable to join channel with topic measurements:" + this.id, resp) });
        channel.on("measurement", event => this.onNewCheckEvent(event) )
    }

    onNewCheckEvent(event) {
        console.log(JSON.stringify(event));
        this.addNewMeasurement(event.timeTaken, event.timestamp);
    }

    updateChart() {
        this.chart.data.datasets[0].data = this.measurements;
        this.chart.update();
    }

    updateStatus() {
        this.statusContainer.childNodes.forEach(child => {
            child.classList.add("d-none");
        });

        switch (this.status) {
            case "ok":
                this.statusContainer.getElementsByClassName("status-success").forEach(element => {
                    element.classList.remove("d-none");
                });
                break;
            case "warning":
                this.statusContainer.getElementsByClassName("status-warning").forEach(element => {
                    element.classList.remove("d-none");
                });
                break;
            case "danger":
                this.statusContainer.getElementsByClassName("status-danger").forEach(element => {
                    element.classList.remove("d-none");
                });
                break;
            default:
                this.statusContainer.getElementsByClassName("status-unknown").forEach(element => {
                    element.classList.remove("d-none");
                });
        }
    }
}

window.createService = createService;