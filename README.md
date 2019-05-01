# DDNS updates for gandi.net domains on Edgerouter X

The Edgerouter X ddnsclient does not support the gandi.net API. 
To update the ip of the A record of your domain on gandi.net this script gets [your current external IP](https://dynamic.zoneedit.com/checkip.html), checks if it matches the configured IP on the A record of your domain and if not it updates the A record to your current external IP.
The script also works if you are behind a NATed internet connection because it gets the current ip form an external service.


* Create an A record for your subdomain (e.g. www.example.com) on gandi. Choose any IP (e.g. 1.2.3.4) to fill the required ip field.
* Generate an API key for the gandi api under `https://account.gandi.net/en/users/<your_username>/security`
* Log via ssh into your edgerouter: `ssh ubnt@192.168.1.1`
* Get root: `sudo su`
* Create bash script in the user space of your edgerouter: `vi /config/user-data/update_gandi_ddns.sh`
* Copy the content of [update_gandi_ddns.sh](https://raw.githubusercontent.com/georgr/erx-gandi-nat-ddns/master/update_gandi_ddns.sh) into the file and save it
* Make the script executable: `chmod a+x /config/user-data/update_gandi_ddns.sh`
* Test your script: `sh /config/user-data/update_gandi_ddns.sh YOUR_API_KEY www.example.com`
* If it works you´ll see something like `{"message": "DNS Record Created"}`
* You can now check on the gandi web interface if [your current external IP](https://dynamic.zoneedit.com/checkip.html) matches the A record ip of your subdomain.
* If your current ip matches the configured A record ip, there is no script output, to test ist you can configure any other ip on the A record on the gandi web interface.
* Set a cronjob to run the script every minute and check if your external ip got updated: `(crontab -l ; echo "* * * * *  /config/user-data/update_gandi_ddns.sh YOUR_API_KEY www.example.com") | crontab -`
