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

// A class representing a single service (minor or mayor)
// Keeps track of the measurements and the status of the service and updates the chart accordingly (if given)
export class Service {
    constructor(id, chartCanvas, statusContainer, measurements) {
        this.id = id;
        this.statusContainer = statusContainer;
        this.measurements = measurements;
        this.statusCallbacks = [];

        if (chartCanvas !== null) this.chart = buildChartFromMeasurements(chartCanvas, this.measurements);
        this.updateStatus();
    }

    addNewMeasurement(timeTaken, timestamp) {
        let data = {
            t: moment.unix(timestamp).utc().tz(moment.tz.guess()), // Convert timestamp to local time of user
            y: timeTaken
        };
        this.measurements.push(data);
        this.updateChart();
        this.updateStatus();
    }

    addStatusCallback(fun) {
        this.statusCallbacks.push(fun);
    }

    setStatus(status) {
        let old_status = this.status;
        this.status = status;
        if (old_status !== this.status) { // If the status changed call all registered callbacks
            this.statusCallbacks.forEach(fun => fun(status));
        }
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
        if (this.chart === null) return; // Do not update the chart if it does not exist (minor services)

        this.chart.data.datasets[0].data = this.measurements;
        this.chart.update();
    }

    updateStatus() {
        if (this.measurements.length === 0) {
            this.setStatus("unknown");
        } else if (this.measurements[this.measurements.length - 1].y !== null) {
            this.setStatus("ok");
        } else if (this.measurements.length === 1) {
            this.setStatus("warning");
        } else {
            if (this.measurements[this.measurements.length - 2] !== null) {
                this.setStatus("warning");
            } else {
                this.setStatus("danger");
            }
        }

        this.updateStatusContainer();
    }

    updateStatusContainer() {
        Array.from(this.statusContainer.getElementsByTagName("span")).forEach(child => {
            child.classList.add("d-none");
        });

        switch (this.status) {
            case "ok":
                Array.from(this.statusContainer.getElementsByClassName("status-success")).forEach(element => {
                    element.classList.remove("d-none");
                });
                break;
            case "warning":
                Array.from(this.statusContainer.getElementsByClassName("status-warning")).forEach(element => {
                    element.classList.remove("d-none");
                });
                break;
            case "danger":
                Array.from(this.statusContainer.getElementsByClassName("status-danger")).forEach(element => {
                    element.classList.remove("d-none");
                });
                break;
            default:
                Array.from(this.statusContainer.getElementsByClassName("status-unknown")).forEach(element => {
                    element.classList.remove("d-none");
                });
        }
    }
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

// Keeps track of the overall status and updates the top status banner if needed
export class OverallStatus {
    constructor() {
        this.childServices = [];
    }

    addMayorService(service) {
        this.childServices.push(service);
        let overallStatus = this;
        service.addStatusCallback(function (status) {
            if (status === "ok") overallStatus.updateStatus();
            else overallStatus.updateStatus(status);
        });
    }

    updateStatus(status) {
        // If no status was defined look at the child services for more information
        if (status === undefined) {
            // If at least one child service is not reachable then declare the host as impacted
            status = this.childServices.some(function (service) {
                return service.status !== "ok";
            }) ? "warning" : "ok";
        }

        document.getElementById("overall-status-success").classList.add("d-none");
        document.getElementById("overall-status-warning").classList.add("d-none");

        switch (status) {
            case "ok":
                document.getElementById("overall-status-success").classList.remove("d-none");
                break;
            default:
                document.getElementById("overall-status-warning").classList.remove("d-none");
                break;
        }
    }
}

export function createOverallStatus() {
    return new OverallStatus();
}

window.createService = createService;
window.createOverallStatus = createOverallStatus;