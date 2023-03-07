# ide

My ide docker image and dotfiles.

## IDE Docker Image

### Build Image

```shell
docker build -t prchann/ide .
```

### Run Image

```shell
docker run --name ide -v /data:/data -p 2222:22 --restart=always -d prchann/ide
```

## dotfiles

### Install

```shell
curl -sL https://raw.githubusercontent.com/prchann/ide/main/install.sh | bash
```

## More

### Init macOS

```shell
curl -sL https://raw.githubusercontent.com/prchann/ide/main/init-macos.sh | bash
```
