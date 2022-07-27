FROM node:lts
ENV NODE_ENV=dev

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/


COPY . .
RUN npm install
# RUN rm .env
# RUN rm -rf .nuxt
# RUN rm -rf .run

EXPOSE 3000
ENV NUXT_HOST 0.0.0.0
ENV HOST 0.0.0.0

ENV NUXT_PORT 3000
# Install app dependencies
CMD [ "npm", "run", "buildStart"]