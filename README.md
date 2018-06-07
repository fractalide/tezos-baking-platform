using docker for bake monitor
-----------------------------

create docker image (with nix)

    $ docker load -i $(nix-build -A bake-central-docker --no-out-link)
    $ docker run -p=127.0.0.1:8000:8000 tezos


