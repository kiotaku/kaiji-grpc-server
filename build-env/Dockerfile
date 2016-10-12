FROM ruby

RUN set -x && \
    apt update -y && \
    apt upgrade -y && \
    apt install protobuf-compiler -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    gem install grpc grpc-tools

CMD grpc_tools_ruby_protoc --ruby_out=/host/protoc_ruby/ --grpc_out=/host/protoc_ruby/ -I /host/kaiji-protoc/ /host/kaiji-protoc/*
