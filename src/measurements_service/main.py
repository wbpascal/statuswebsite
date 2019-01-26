from influxdb import InfluxDBClient
from flask import Flask,request
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
	#get required Parameters
	startTime  = request.args.get('startTime')
	endTime    = request.args.get('endTime')
	groupBy    = request.args.get('groupBy')
	# check required parameters
	if not startTime:
		return "startTime required"
	if not endTime:
		return "endTime required"
	if not groupBy:
		return "groupBy required"
	#optional Parameters
	#serviceId    = request.args.get('serviceId')
	# GROUP BY time({gb}),gb=groupBy
	rstr = "select MEAN(execution_time),Count(time) from http,ping4 WHERE time >= {s} AND time <= {e} GROUP BY time({gb}) LIMIT 30;".format(s=startTime,e=endTime,gb=groupBy)
	response  = client.query(rstr)
	#result = ""
	#for p in response.get_points():
    #	result += str(p)
	#result = str(response)#str(json.dumps(response))
	
	
	#exam
	#startTime
	#endTime
	#groupBy
	#serviceId?
	#result = ""
	#r1 = client.query("select * from http;")
	#r2 = client.query("select * from ping4;")
	#result += str(json.dumps(r1._raw.__dict__))
	#result += str(json.dumps(r2._raw.__dict__))
	return json.dumps(response.raw)
	
if __name__ == "__main__":
    main()
