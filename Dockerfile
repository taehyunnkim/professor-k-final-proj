# Build stage
FROM node:14 AS build
ENV PORT=7777
WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm install
COPY frontend/ ./
RUN sed -i 's#http://localhost:7777/#https://vulnalert.app/#' src/authConfig.js
RUN npm run build


# Production stage
FROM node:14-alpine
WORKDIR /app/backend
COPY backend/package*.json ./
RUN npm install --production
COPY backend/ ./
COPY --from=build /app/frontend/build /app/frontend/build
EXPOSE $PORT
CMD ["npm", "run", "deploy"]