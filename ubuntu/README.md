## Developer environment setup

> Last checked `Ubuntu 22.04.1`

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

- By running this command, user config will be updated and reboot system

```shell
make setup-complete
```

# Throwable shot

> Ubuntu 24.04 installer was crashing. Try to launch the installer by using, reference
> from [24.04 installer keeps crashing](https://www.reddit.com/r/Ubuntu/comments/1cd6tkg/2404_installer_keeps_crashing/)

````shell
 env BAMF_DESKTOP_FILE_HINT=/var/lib/snapd/desktop/applications/ubuntu-desktop-bootstrap_ubuntu-desktop-bootstrap.desktop LIBGL_ALWAYS_SOFTWARE=1 /snap/bin/ubuntu-desktop-bootstrap
````

