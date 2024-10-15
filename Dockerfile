FROM node:18-slim AS installer

ARG NODE_ENV=production
ENV NODE_ENV $NODE_ENV

ARG PORT=3000
ENV PORT $PORT
EXPOSE $PORT 9229 9230

RUN npm i npm@latest -g

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

WORKDIR /app

COPY package*.json ./
RUN npm install 

COPY . .

RUN npm run build

FROM nginx:latest AS deployer

COPY --from=installer /app/build /usr/share/nginx/html
