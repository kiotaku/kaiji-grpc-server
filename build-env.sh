docker build -t protoc-compile -f ./build-env/Dockerfile-protoc ./build-env
docker run -v /c/Users/takumi/Documents/3J/kaiji-grpc-server/:/host/ protoc-compile
