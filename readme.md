To connect to a vm input this into cloud sdk shell:

gcloud compute start-iap-tunnel <instance-name> 5901 --local-host-port=localhost:5901

and then connect to localhost:5901 using e.g. RealVNC Viewer. The tightvncserver was configured with these steps https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-vnc-on-debian-11.