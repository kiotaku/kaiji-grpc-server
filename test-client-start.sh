docker run --name test-client -it -v /c/Users/takumi/Documents/3J/kaiji-grpc-server/:/app/ --link game-database:mysql --link game-server:game-server test-client-base
