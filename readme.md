To connect to a vm input this into cloud sdk shell:

gcloud compute start-iap-tunnel apache-instance-0ln2 5901 --local-host-port=localhost:5901

and then connect to localhost:5901 using e.g. RealVNC Viewer.