FROM node:18

WORKDIR /app

COPY package.json package-lock.json* ./
RUN npm cache clean --force && \
    npm install -g npm@latest && \
    npm install

COPY . .

ENV NEXT_TELEMETRY_DISABLED 1

RUN npm run build

ENV NODE_ENV production

ENV NEXT_TELEMETRY_DISABLED 1

USER 10014
EXPOSE 3000

ENV HOSTNAME 0.0.0.0
ENV PORT 3000

CMD ["./node_modules/.bin/next", "start"]