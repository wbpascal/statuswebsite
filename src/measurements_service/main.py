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
        rstr = "select * from ping4 where service != 'ping4' LIMIT 3;"
        #rstr = "select * from http where service != 'http' LIMIT 3;"
        response  = client.query(rstr)
        return json.dumps(response.raw)


def point_to_json(sid,p):
        r = "{"
        r += '"serviceId": {},'.format(sid)
        r += '"responseTime": {},'.format(p['mean'])
        r += '"startTime": {},"endTime": {},'.format(p['min'],p['max'])
        r += '"measurementCount": {},"outages": {},"tries": {}'.format(p['count'],0,0)
        r += "},"
        return r
        
@app.route('/measurements/')
def measurements():
        #get required Parameters
        startTime  = request.args.get('startTime')
        endTime    = request.args.get('endTime')
        groupBy    = request.args.get('groupBy')
        serviceId    = request.args.get('serviceId')
        # check required parameters
        if not startTime:
                return "startTime required"
        if not endTime:
                return "endTime required"
        if not groupBy:
                return "groupBy required"
        if not serviceId:
                return "serviceId required"
        
        # GROUP BY time({gb}),gb=groupBy
        # MEAN(execution_time),Count(time)
        # (COUNT(time)-SUM(reachable))
        rstr = "select MEAN(execution_time),MIN(time),MAX(time),COUNT(time) from http"
        rstr += "WHERE time >= {s} AND time <= {e} AND service = {sid} GROUP BY time({gb});".format(s=startTime,e=endTime,sid=serviceId,gb=groupBy)
        response  = client.query(rstr)
        result = "["
        for r in response.get_points():
                result += point_to_json(serviceId,r) + "\n"
        
        result += "]"
        return result
        
        
if __name__ == "__main__":
    main()
