# NAS Control

This project provides a web interface to wake up a NAS device using Wake-on-LAN (WoL). It includes a lightweight web server (Lighttpd) and CGI scripts to handle WoL requests and check the status of the NAS.

**Note**: This README was generated by a GPT LLM. Please verify the steps and adapt them to your specific environment.

---

## Features
- Web interface to send Wake-on-LAN packets.
- Status indicator to show if the NAS is online or offline.
- Lightweight and designed to run on resource-constrained devices like OpenWrt routers.

---

## Prerequisites
- Docker (for building and testing)
- OpenWrt router with SSH access

---

## Steps to Build, Test, Run, and Deploy

### 1. Build the Docker Image
To build the Docker image for testing and development:

```bash
docker build -t nas-control .
```

### 2. Test the Docker Image
```bash
# run test
docker run --rm nas-control /test/run_tests.sh
# (optional deploy mocked version)
docker run --rm -p 8080:80 --env USE_MOCK=true --name nas-control nas-control
```

### 3. Run the Docker Image
```bash
docker run --rm -p 8080:80 -v congfig_asb_dir/:/var/www/config/ --name nas-control nas-control
```

### 4. Deploy on router
