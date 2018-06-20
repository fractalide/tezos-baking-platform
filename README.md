using docker for bake monitor
-----------------------------

create docker image (with nix)

    $ docker load -i $(nix-build -A bake-central-docker --no-out-link)
    $ docker run -p=127.0.0.1:8000:8000 tezos-bake-monitor --pg-connection=<conn string> --root-url=http://172.0.0.1:8000


