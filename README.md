# nginxLoadBalancer

A small project to create a simple LoadBalancer, using Nginx to redirect to 4 other servers spun up using Docker.
(for my own learning)

## Technology & Learning

Nginx:

- using it as a proxy server

Docker:

- Building a Image (`docker build`)
- Spinning up the images (`docker run`)

## Process/Guide

---

### NGINX

for Mac users:
`brew install nginx`

To Run:

> `nginx`

see if it works, go to URL, and type localhost:8080. (will show up as "Welcome to nginx!")  
Default _nginx.conf_ file setting, port is opedn at 8080.

To Stop:

> `nginx -s stop`

we can find the nginx folder using: `nginx -t`

**Impt!!** every time we want to **make changes** to the nginx need to run `nginx -s reload`

---

### Dockerized Servers

#### To create a script

create a directory with `mkdir` and then `cd` into the directory

- first `npm init`
- then intall express : `npm install express`

create a simple _index.js_ script:

```javascript
const express = require("express");

const app = express();

app.get("/", (req, res) => {
  res.send("I am a endpoint");
});

app.listen(7777, () => {
  console.log("listening on port 7777");
});
```

if we run node _index.js_ according to the script, then it will open the port at 7777, and we can reach the endpoint.

#### Using Docker to spin up Servers

create _dockerfile_

```dockerfile
FROM node:18

# Create app directory, and set the working directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
# WE COPY the package.json
COPY package*.json ./

RUN npm install
# If you are building your code for production
# RUN npm ci --omit=dev

# Bundle app source
COPY . .

#EXPOSE 8080
EXPOSE 7777
# change to 7777, since the previous step, we initialize and open port at 7777


# this CMD means: ( to run > npm node index.js, inside the terminal in docker )
CMD ["node", "index.js"]
```

##### Building the docker IMAGE

run

> docker build . -t myserver
<img width="1021" alt="Screenshot 2023-07-04 at 6 31 18 PM" src="https://github.com/Glow-in-the-dark/nginxLoadBalancer/assets/2751458/4f041be9-5b82-4059-89ab-9ba29b75c99c">


(-t flag is to tag it with a name, in this case we name it "myserver")

> docker run -p 1111:7777 -d myserver

> docker run -p 2222:7777 -d myserver

> docker run -p 3333:7777 -d myserver

> docker run -p 4444:7777 -d myserver

<img width="1242" alt="Screenshot 2023-07-04 at 6 31 52 PM" src="https://github.com/Glow-in-the-dark/nginxLoadBalancer/assets/2751458/c3a517f5-1486-47ca-9ce2-387ea853bcfe">


to spin out 4 servers, which we map the different ports to the ports of the NGINX server to the opened ports in the docker container which is 7777

---

### Now, to configure nginx.conf file again to make it into a LOAD BALANCER

edit the _nginx.conf_ file and add the the `upstream backendserver {}` and also use the `proxy_pass` to make it rotate around the for servers.

```
http {
		include mime.types; # if we never use this, everything will be rendered as text/plain. so no CSS or others will be rendered

		# specify our backend, we can call it backendserver or any thing
		upstream backendserver {
				server 127.0.0.1:1111;
				server 127.0.0.1:2222;
				server 127.0.0.1:3333;
				server 127.0.0.1:4444;
		}

		server {
				listen 8080; # listening port
				root /Users/glow/Desktop/testNgnix; # the filePATH, that the bunch of file which we want to serve

				location / {
						#this proxy_pass will automatically do a roundrobin around all the listed server above.
						proxy_pass http://backendserver/;
				}
				location /fruits {
						root /Users/glow/Desktop/testNgnix;
						# if u search localhost:8080/fruits, it will go to this path: /Users/glow/Desktop/testNgnix/fruits ( the fruits folder, in the root PATH)
						# how it works is that, it will append "/fruits" to the end of the root path.
				}
				# location / means, everytime once it hit "/" directory immediately do the code below

				location /carbs {
						alias /Users/glow/Desktop/testNgnix/fruits;
						# alias will not append the location path to the end of the "alias" path. It will go Directly to the path
				}

		}
}

# don't need to use events{} , but we just need to define for nginx to work
events{}
```
