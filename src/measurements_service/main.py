from influxdb import InfluxDBClient
from flask import Flask
import json
import os

app = Flask(__name__) # Needs to be here so we can compile because the @app.route annotation needs this before main() is run

def main():
	global client
	user = os.environ['INFLUX_USER']
	password = os.environ['INFLUX_PASS']
	client = InfluxDBClient(host='influxdb-influxdb', port=8086, username=user, password=password, database='icinga2')
	debug = os.environ['FLASK_ENV'] == 'debug'
	app.run(debug=debug, host='0.0.0.0', port=5000)

	
@app.route('/')
def test():
	return "test"



	
@app.route('/measurements/')
def measurements():
	#exam
	#startTime
	#endTime
	#groupBy
	#serviceId?
	result = client.query("select value from data;")
	return json.dumps(restult.__dict__)
	
if __name__ == "__main__":
    main()
