# ./Dockerfile
FROM node:20-alpine
WORKDIR /app

# installe d’abord les deps
COPY package*.json ./
RUN npm install

# copie le code
COPY . .

EXPOSE 5173
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]
