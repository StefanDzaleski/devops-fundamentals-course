FROM node:16 as build

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

FROM gcr.io/distroless/nodejs

COPY --from=build /app /
EXPOSE 5000
CMD ["index.js"]