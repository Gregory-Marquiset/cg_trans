docker build -t pong-frontend .

docker run -d -p 8080:80 pong-frontend

http://localhost:8080

# pour clean
docker ps
docker stop <ID>
docker rm <ID>
