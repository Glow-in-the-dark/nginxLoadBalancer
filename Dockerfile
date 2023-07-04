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


# this CMD means: ( to run > npm run start, inside the terminal in docker )
CMD ["npm", "run", "start"]