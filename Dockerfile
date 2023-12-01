FROM node:18-alpine AS base

FROM base AS deps

RUN apk add --no-cache libc6-compat

WORKDIR /pages

COPY package.json package-lock.json

RUN npm config set registry 'https://registry.npmmirror.com/'
RUN npm install

FROM base AS builder

RUN apk update && apk add --no-cache git

WORKDIR /pages
COPY --from=deps /app/node_modules ./node_modules
COPY . .

RUN npm build

FROM base AS runner
WORKDIR /pages

RUN apk add proxychains-ng

COPY --from=builder /pages/public ./public
COPY --from=builder /pages/.next/standalone ./
COPY --from=builder /pages/.next/static ./.next/static
COPY --from=builder /pages/.next/server ./.next/server

EXPOSE 3000

CMD export HOSTNAME="127.0.0.1"; \
    node server.js;
