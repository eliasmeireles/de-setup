## Developer environment setup

- Before start, run the commands bellow

```shell
sudo apt update && sudo apt install -y git make && git clone https://github.com/eliasmeireles/de-setup.git && cd de-setup/ubuntu 
```

## Run setup

- By running the command bellow, a full setup will be executed
- If you want to disable an installation, just comment installer line on [runner.conf](runner.conf) 

```shell
make setup-run
```

- Install node
```shell
make install-node
```

