# Einrichtung der Entwicklungs-VM
Folgende Schritte müssen jedes mal **im Projektordner** ausgeführt werden, bevor am Projekt entwickelt werden kann.

1. `vagrant up`: Erstellt beim ersten mal die Virtuelle Maschine, auf der sich das Kubernetes Cluster befindet (kann länger daueren, bis 20 Minuten). Nach dem erstmaligen Starten kann es sein, dass noch nicht alle Dienste verfügbar sind. Nach ein wenig warten (~5 Minuten) sollten sie aber spätestens vorhanden sein. Nachdem die VM erstellt wurde fährt dieser Befehl sie nur noch hoch.
2. `vagrant ssh`: Erstellt eine SSH-Sitzung, die sich zur VM verbindet, sodass Befehle in ihr ausgeführt werden können. **Alle folgenden Befehle in dieser Anleitung werden in der VM ausgeführt.**
3. `cd /vagrant`: Hier sind alle Dateien aus dem Projektordner zu finden.
4. `cd src && skaffold up`: Erstellt alle Projekte, die in `src/skaffold.yml` referenziert wurden und startet sie im Kubernetes Cluster. Danach wartet der Befehl auf Änderungen in den Projekt-Dateien.
5. Jetzt kann auf dem Host-PC (sowie der VM) entwickelt werden und Änderungen werden automatisch im Kubernetes Cluster gebaut und ausgeführt.

Wenn die VM heruntergefahren werden soll müssen zunächst alle SSH-Sitzungen getrennt werden (`exit` in jeder Sitzung aufrufen). Danach kann die VM mithilfe von `vagrant halt` (auf Host-PC) heruntergefahren werden.


# Verfügbare Dienste in der Entwicklungs-VM
Dank dem eingebauten DNS Server von Kubernetes können alle im Cluster der Entwicklungs-VM laufende Container folgende Dienste erreichen:

### InfluxDB
* Hostname: `influxdb-influxdb`
* Port: `8086` (api), `8088` (rpc)
* Benutzername: `admin`
* Passwort: `password`

### Kafka
* Hostname: `kafka` (Broker), `kafka-zookeeper` (Zookeeper)
* Port: `9092` (Broker), `2181` (Zookeeper)

### PostgreSQL
* Hostname: `postgresql`
* Port: `5432` (default für PostgreSQL)
* Benutzername: `postgres`
* Passwort: `postgres`
