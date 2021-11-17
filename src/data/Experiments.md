# Experiments on solo node


## INSTALL UBUNTU-DEPENDENCIES
```
sudo apt-get update
sudo apt-get install build-essential git bubblewrap unzip


# modify /etc/scylla/scylla.yaml


# installed location
/etc/default/scylla-server


```

## CONFIGURE SCYLLA
```

# setup scylla on the machine and start
sudo scylla_setup


# startup of service
sudo systemctl start scylla-server

```

## Install OPAM/OCAML

```
bash -c "sh <(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)"

# environment setup
opam init
eval $(opam env)
# install given version of the compiler
opam switch create 4.12.0
eval $(opam env)
# check you got what you want
which ocaml
ocaml -version

opam install dune irmin lwt lwt_ppx ppx_irmin

```

## Install SCYLLA OCAML BINDINGS

```
opam pin add scylla git+https://git@github.com/gowthamk/ocaml-scylla

```

## Install DOCKER

```
 $ sudo apt-get update

 $ sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

 $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg


 $ echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


 $ sudo apt-get update

 $ sudo apt-get install docker-ce docker-ce-cli containerd.io

```

## Install REPOSITORY

```
git clone https://github.com/cuplv/merge-experiments.git

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

dune build

```

## Install Docker-Compose

(reference)[https://docs.docker.com/compose/install/]
```
 sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose


sudo chmod +x /usr/local/bin/docker-compose


sudo docker-compose --version
```


## Test execution

### Startup the ScyllaDB instances
```
sudo docker-compose up -d
sudo docker container ls


sudo docker exec -it scylla nodetool status

sudo docker exec -it scylla cqlsh

```

## Conduct Single Monkey Experiment

```

```