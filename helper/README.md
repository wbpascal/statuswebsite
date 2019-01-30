# Helper Scripts

## Requirements
Before using the the helper scripts you have to install the requirements by running `pip install -r requirements.txt`.

## dummy_data.py
This script can be used to insert some dummy data into Icinga and MariaDB to test with them. Before calling the script make sure that Icinga and MariaDB are running and that the schemas of MariaDB are on the newest version (by running `monitored_service` once in the cluster, which runs all migrations). After that you can run the script with `python dummy_data.py`.