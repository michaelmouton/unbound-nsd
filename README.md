# Unbound DNS in a container!

This is a small project where I have configured Unbound as a simple recursive DNS server.  I.e. any quaries made will be passed on to the authoritative DNS nameservers.

The container is build on Alpine Linux, with additional packages installed from their repository.

## Building and deploying on local hardware

Clone the GitHub repository.

```
git clone https://github.com/michaelmouton/unbound-nsd
cd unbound-nsd
```

Build for your hardware.

```
sudo docker build -t unbound .
```

Deploy via Docker Run.

```
sudo docker run -d --restart=always -p 53:53/tcp -p 53:53/udp --name=unbound_svr unbound
```

## Building for non-local hardware

Make sure you can build for any architecture, regardless of the host machine.

```
sudo docker run --privileged --rm tonistiigi/binfmt --install all
```

Clone the GitHub repository.

```
git clone https://github.com/michaelmouton/unbound-nsd
cd unbound-nsd
```

Run one of these four commands, depending on the target hardware.

```
sudo docker buildx build --platform "linux/amd64" -t unbound .
sudo docker buildx build --platform "linux/arm64" -t unbound .
sudo docker buildx build --platform "linux/arm/v7" -t unbound .
sudo docker buildx build --platform "linux/arm/v6" -t unbound .
```

Export the image.

```
sudo docker save unbound > unbound.tar
```

## Configuring for a Proxmox VE-based LXE container

On Proxmox select a datastore that is capable of storing LXC templates.  Click on the "Templates" button, then search for ```alpine-3.23``` and download the latest build.

Using the Alpine template, create an LXC container on your Proxmox host, and make sure to assign a static IP address.  If you have DHCP on this network also make sure the DNS IP is not in the DHCP IP pool, and condigure the DHCP server to serve the DNS IP.

Start your LXC container, login as ```root```.  Then run the following command...
```
wget -qO- https://raw.githubusercontent.com/michaelmouton/unbound-nsd/refs/heads/main/lxc-builder.sh | sh
```

The ```lxc-builder.sh``` script fully configures your Alpine container with the full DNS stack.  It also creates an OpenRC service which automatically starts once the script finised executing.

Also remember, Alpine Linux is extremely portable, so the boot disk only has to be 256MB (0.25GB) in size.
