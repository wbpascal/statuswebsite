import base64
import json
import pymysql.cursors
import requests
from requests.auth import HTTPBasicAuth
import subprocess


icinga_api_secret = "icinga-api"
icinga_api_secret_pass_key = "password"
icinga_api_service = "icinga-api"
icinga_user = "root"
mariadb_secret = "mariadb"
mariadb_secret_pass_key = "mariadb-root-password"
mariadb_service = "mariadb"
mariadb_user = "root"

class IcingaClient:
	def __init__(self, address, user, password):
		self.address = address
		self.user = user
		self.password = password
		
	def create_object(self, obj_type, name, attrs):
		if obj_type == "Host":
			self.__create_host(name, attrs)
		elif obj_type == "Service":
			self.__create_service(name, attrs)
		
	def __create_host(self, name, attrs):
		url = "{0}/v1/objects/hosts/{1}".format(self.address, name)
		r = requests.put(url, json={"attrs": attrs}, **self.__get_default_request_args())
		print r.text
		
	def __create_service(self, name, attrs):
		url = "{0}/v1/objects/services/{1}".format(self.address, name)
		r = requests.put(url, json={"attrs": attrs}, **self.__get_default_request_args())
		print r.text
		
	def __get_default_request_args(self):
		return {"auth": HTTPBasicAuth(self.user, self.password), "headers": {"Accept": "application/json"}, "verify": False}
	

def get_kube_svc_cluster_ip(service_name):
	kube_cmd = "kubectl get svc {} -o json".format(service_name) 
	kube_process = subprocess.Popen(kube_cmd.split(), stdout=subprocess.PIPE)
	kube_output, error = kube_process.communicate()
	data = json.loads(kube_output)
	return data["spec"]["clusterIP"]
	
def get_kube_secret_contents(secret_name, data_key):
	kube_cmd = "kubectl get secret {} -o json".format(secret_name) 
	kube_process = subprocess.Popen(kube_cmd.split(), stdout=subprocess.PIPE)
	kube_output, error = kube_process.communicate()
	data = json.loads(kube_output)
	return base64.b64decode(data["data"][data_key])
	
icinga_ip = get_kube_svc_cluster_ip(icinga_api_service)
icinga_pass = get_kube_secret_contents(icinga_api_secret, icinga_api_secret_pass_key)
icinga_client = IcingaClient("https://{}:5665".format(icinga_ip), icinga_user, icinga_pass)
with open("icinga_objects.json") as f:
	for icinga_object in json.load(f):
		icinga_client.create_object(icinga_object["type"], icinga_object["name"], icinga_object["attrs"])

mariadb_ip = get_kube_svc_cluster_ip(mariadb_service)
mariadb_pass = get_kube_secret_contents(mariadb_secret, mariadb_secret_pass_key)
mariadb_connection = pymysql.connect(host=mariadb_ip,
                                     user=mariadb_user,
                                     password=mariadb_pass,
                                     db='monitored_services',
                                     charset='utf8mb4',
                                     cursorclass=pymysql.cursors.DictCursor)
try:
	with open("mariadb_objects.json") as f:
		with mariadb_connection.cursor() as cursor:
			for db_object in json.load(f):
				host_id = db_object["id"]
				host_insert_sql = "INSERT INTO `HOSTS` (`id`, `hostName`, `description`, `icon`) VALUES (%s, %s, %s, %s)"
				cursor.execute(host_insert_sql, (db_object["id"], db_object["name"], db_object["description"], db_object["icon"]))
				for svc_object in db_object["services"]:
					svc_insert_sql = "INSERT INTO `SERVICES` (`id`, `serviceName`, `hostID`, `type`) VALUES (%s, %s, %s, %s)"
					cursor.execute(svc_insert_sql, (svc_object["id"], svc_object["name"], host_id, svc_object["type"]))
	mariadb_connection.commit()
finally:
	mariadb_connection.close()
	


