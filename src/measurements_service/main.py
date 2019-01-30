from influxdb import InfluxDBClient
from datetime import datetime
from flask import Flask,request
from itertools import chain

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
        """Test method to check if the connection to the database works"""
        startDate = datetime.fromtimestamp(1548871200).strftime('%Y-%m-%dT%H:%M:%SZ')
        endDate = datetime.fromtimestamp(1548878400).strftime('%Y-%m-%dT%H:%M:%SZ')
        rstr = "select count(state) from http where service = '1' and state != 0 group by time(1h) limit 100;"
        #rstr = "select * from http where time >= 0 AND service = '1' AND unit = 'seconds' LIMIT 30;"
        #rstr = "select MEAN(value),MIN(time),MAX(time),COUNT(time) from http "
        #rstr += "WHERE time >= {s} AND service = '{sid}' AND unit = 'seconds' GROUP BY time({gb});".format(s=0,e=endTime,sid=serviceId,gb=groupBy)
        
        response  = client.query(rstr)
        return json.dumps(response.raw)


def point_to_json(sid,p,p2):
        startDate = int(datetime.strptime(p['time'],'%Y-%m-%dT%H:%M:%SZ').timestamp())
        r = {
                "serviceId": sid,
                "responseTime": int(p['mean']),
                "startTime": startDate,
                "endTime": (startDate+200), # todo: substract interval of starttime
                "measurementCount": int(p['count']),
                "outages": int(p2),
                "tries": 0
        }
        return r
        
@app.route('/healthz')
def health():
        return json.dumps({'success':True}), 200, {'ContentType':'application/json'} 

@app.route('/measurements/')
def measurements():
        #get required Parameters
        startTime  = request.args.get('startTime')
        endTime    = request.args.get('endTime')
        groupBy    = request.args.get('groupBy')
        serviceId  = request.args.get('serviceId')
        # check required parameters
        if not startTime or not endTime or not groupBy or not serviceId:
            return json.dumps({'success':False}), 400, {'ContentType':'application/json'} 
        startDate = datetime.fromtimestamp(int(startTime)).strftime('%Y-%m-%dT%H:%M:%SZ')
        endDate = datetime.fromtimestamp(int(endTime)).strftime('%Y-%m-%dT%H:%M:%SZ')
        
        result = []
        for t in ["http","ping4"]:
                # get reaction time
                rstr = "select MEAN(value),count(value) from {} ".format(t)
                rstr += "WHERE time >= '{s}' AND time <= '{e}' AND service = '{sid}' AND unit = 'seconds' GROUP BY time({gb});".format(s=startDate,e=endDate,sid=serviceId,gb=groupBy)
                response  = client.query(rstr)
                # get success
                rstr2 = "select count(state) from {} ".format(t)
                rstr2 += "WHERE time >= '{s}' AND time <= '{e}' AND service = '{sid}' AND state != '0' AND state != 'null' GROUP BY time({gb});".format(s=startDate,e=endDate,sid=serviceId,gb=groupBy)
                response2  = client.query(rstr2)
                outGen = chain([x.point['count'] for x in response2.get_points()],iter(int,1))
                for r,s in zip(response.get_points(), outGen):
                    if r['count'] and r['count'] != "0":
                        result.append(point_to_json(serviceId,r,s))

        return json.dumps(result)
        
        
if __name__ == "__main__":
    main()
