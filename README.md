# kaiji-grpc-server
文化祭で行うゲームのサーバー部分

## 起動方法
    $ ./init/server.sh
    $ ./init/database.sh
    $ ./build-env.sh
    $ ./build-server.sh
    $ ./build-http-server.sh
    $ ./database-start.sh
    $ ./server-start.sh
    $ ./http-server-start.sh

## shell script
1. init/
  1. 初めに一回起動すべき設定群
1. build-env.sh
  1. protoファイルのコンパイル用
1. build-server.sh
  1. server用docker imageの作成用
1. database
  1. database-start.sh
    1. database用docker containerの作成用
  1. database-create.sh
    1. docker container作成後の初期設定用
  1. database-stop.sh
    1. dacker containerの削除用ただしデータは消えない
  1. database-init-data.sh
    1. database用docker containerのデータ初期化用
    1. これを起動した場合database-create.shをもう一度起動する必要がある
1. server
  1. server-start.sh
    1. server用docker containerの作成用
  1. server-start-dev.sh
    1. server用docker containerの作成用ただし開発向け
  1. server-stop.sh
    1. server用docker containerの一時停止用
  1. server-delete.sh
    1. server用docker containerの削除用
    1. server-start.shの起動時データを書き換えたい場合はこれを動かした後にbuild-server.shを使うこと
