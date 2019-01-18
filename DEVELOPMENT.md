# Einrichtung der Entwicklungs-VM
Folgende Schritte müssen jedes mal **im Projektordner** ausgeführt werden, bevor am Projekt entwickelt werden kann.

1. `vagrant up`: Erstellt beim ersten mal die Virtuelle Maschine, auf der sich das Kubernetes Cluster befindet (kann länger daueren, bis 20 Minuten). Nach dem erstmaligen Starten kann es sein, dass noch nicht alle Dienste verfügbar sind. Nach ein wenig warten (~5 Minuten) sollten sie aber spätestens vorhanden sein. Nachdem die VM erstellt wurde fährt dieser Befehl sie nur noch hoch.
2. `vagrant ssh`: Erstellt eine SSH-Sitzung, die sich zur VM verbindet, sodass Befehle in ihr ausgeführt werden können. **Alle folgenden Befehle in dieser Anleitung werden in der VM ausgeführt.**
3. `cd /vagrant`: Hier sind alle Dateien aus dem Projektordner zu finden.
4. `cd src && forge deploy`: Erstellt alle Projekte, in deren Ordner eine `service.yaml` gefunden wurde und startet sie im Kubernetes Cluster. Jedes mal, wenn Änderungen an den Projektdateien im Kubernetes Cluster übernommen werden sollen, muss dieser Befehl erneut ausgeführt werden.
5. Jetzt kann auf dem Host-PC (sowie der VM) entwickelt werden.

Wenn die VM heruntergefahren werden soll müssen zunächst alle SSH-Sitzungen getrennt werden (`exit` in jeder Sitzung aufrufen). Danach kann die VM mithilfe von `vagrant halt` (auf Host-PC) heruntergefahren werden.


# Verfügbare Dienste in der VM
Dank dem eingebauten DNS Server von Kubernetes können alle im Cluster der VM laufende Container folgende Dienste erreichen:

### Icinga 2 API
* Hostname: `icinga-api`
* Port: `5665`
* Passwort: Im Secret `icinga-api` zu finden

### InfluxDB
* Hostname: `influxdb-influxdb`
* Port: `8086` (api), `8088` (rpc)
* Benutzername: `admin`
* Passwort: Im Secret `influxdb-influxdb-auth` zu finden

### MariaDB
* Hostname: `mariadb`
* Port: `3306`
* Benutzername: `maria`
* Passwort: Im Secret `mariadb` zu finden

### RabbitMQ
* Hostname: `rabbitmq`
* Port: `5672` (amqp), `15672` (manager)
* Passwort: Im Secret `rabbitmq` zu finden


# Erreichen von Diensten mithilfe ihrer IPs zu Testzwecken
Alle gestarteten Dienste im Kubernetes Cluster auf der VM können über eine eigens eingerichtete Netzwerkbrücke vom Host-PC aus erreicht werden. Dazu muss der Host-PC zunächst wissen, wo der Adressbereich der Dienste (`10.233.0.0/16`) zu finden ist. Das kann folgendermaßen erreicht werden (auf dem Host-PC):

Linux:
```
sudo ip route add 10.233.0.0/16 via 10.10.0.2
```

Windows:
```
route add 10.233.0.0 mask 255.255.0.0 10.10.0.2
```

OSX:
```
sudo route -n add 10.233.0.0/16 10.10.0.2
```

Jetzt können die IPs der Dienste im Cluster direkt von dem Host-PC angesprochen werden. Für eine Möglichkeit, wie man die IP Adressen herausfindet, kann sich am Kubernetes Cheatsheet (unten) orientiert werden.


# Kubernetes Cheatsheet

Auflistung aller im Standard-Namensraum des Cluster laufenden Programme ([Pods](https://kubernetes.io/docs/concepts/workloads/pods/pod/)):
```
kubectl get pods
```

Auflistung aller im Standard-Namensraum des Cluster laufenden [Dienste](https://kubernetes.io/docs/concepts/services-networking/service/) (Permanenter Ort, an dem man das entsprechende Programm erreichen kann) und ihre IP Adressen:
```
kubectl get svc
```
