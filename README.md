# kaiji-grpc-server
文化祭で行うゲームのサーバー部分

## 起動方法
    $ docker-compose build
    $ docker-compose run --rm game-server bundle rake create migrate
    $ docker-compose up
