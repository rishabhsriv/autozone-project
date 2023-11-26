FROM node:19.5.0-alpine
ARG app_location=/usr/src/app
WORKDIR ${app_location}

COPY . ${app_location}
RUN npm install 

EXPOSE 3000
CMD ["npm","run","dev"]
