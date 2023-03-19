# ide

My dotfiles and ide docker image.

## Install

### Install Apps

```shell
bash <(curl -sL https://raw.githubusercontent.com/prchann/ide/main/install-apps.sh)
```

### Install Dotfiles

```shell
bash <(curl -sL https://raw.githubusercontent.com/prchann/ide/main/install-dotfiles.sh)
```

## IDE Docker Image

### Build Image

```shell
docker build -t prchann/ide .
```

### Run Image

```shell
docker run --name ide -v /data:/data -p 2222:22 --restart=always -d prchann/ide
```
