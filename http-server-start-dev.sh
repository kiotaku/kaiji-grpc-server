docker run --name http-server -it -v /c/Users/takumi/Documents/3J/kaiji-grpc-server/:/app/ --link game-database:mysql -p 80:80 my-http-server
