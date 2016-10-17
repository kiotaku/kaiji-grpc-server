docker run -d --name game-server -p 1257:1257 --link game-database:mysql my-grpc-server
