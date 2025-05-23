docker build -t pong-backend .

docker run -d -p 3000:3000 pong-backend

http://localhost:3000

# pour clean
docker ps
docker stop <ID>
docker rm <ID>
