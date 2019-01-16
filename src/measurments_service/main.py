from influxdb import InfluxDBClient
from flask import Flask
import json

def main():
	global client, app
	password = sys.argv[1]
	client = InfluxDBClient(host='influxdb-influxdb', port=8086, username='admin', 
	password=password, database='icinga2')
	app = Flask(__name__)

	
@app.rpoute('/')
def test():
	return "test"



	
@app.rpoute('/measurements/')
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