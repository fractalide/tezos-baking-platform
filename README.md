Running the Bake Monitor via Docker
-----------------------------------

1) Build the bake monitor Docker image via `nix`.

```shell
docker load -i $(nix-build -A bake-central-docker --no-out-link)
```

2) Create a Docker network to connect multiple containers.

```shell
docker network create tezos-bake-network
```

3) Start a Postgres database instance in the network.

```shell
docker pull postgres
docker run --name bake-monitor-db --detach --network tezos-bake-network -e POSTGRES_PASSWORD=secret postgres
```

4) Start the bake monitor Docker container in the same network and connect it to the appropriate database.

```shell
docker run --rm -p=8000:8000 --network tezos-bake-network tezos-bake-monitor --pg-connection='host=bake-monitor-db dbname=postgres user=postgres password=secret'
```

5) Visit the bake monitor at http://localhost:8000.
