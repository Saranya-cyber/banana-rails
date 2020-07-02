# AWS Staging Server Instructions

## Notes 
1. We're using docker for the postgres database and the database is reset with each deploy.
2. The current instance is the cheapest one you can buy (t2.micro) in the 
east coast availability zone.  We'll have to see how this works out in 
terms of performance. We can consider using a bigger instance; switching to the west
coast availability zone or something like digital ocean.

## To set up and use new CD server
1. Create new EC2 instance using an ubuntu image (ami-0ac80df6eff0e70b5 is what was used initially)
2. Save the ssh keypair and make note of the public DNS
3. ssh to the new instance `"ssh ~/.ssh/banana.pem" ubuntu@<public-dbs>`
4. On the new EC2 instance install the following software. We can automate this as part of instance creation or save a new AWS image later.
    1. `sudo apt-get update`
    2. `curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -`
    3. `sudo add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
               $(lsb_release -cs) \
               stable"`
    4. `sudo apt-get update`
    5. `sudo apt-get install docker-ce docker-ce-cli containerd.io`
    6. `sudo curl -L "https://github.com/docker/compose/releases/download/1.26.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose`
    7. `sudo chmod +x /usr/local/bin/docker-compose`
5. Create a ssh keypair on the EC2 instance as described [here](https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key) 
and copy the public key to your clipboard and add it as deploy key for the repo: https://github.com/FoodIsLifeBGP/banana-rails/settings/keys
6. Add or update the `STG_SERVER` secret to the public DNS https://github.com/FoodIsLifeBGP/banana-rails/settings/secrets 
(you'll need to be a repo owner)
7. Add or update the `STG_PRIVATE_KEY` secret so that it's the private key string from step 2.


    
