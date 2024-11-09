# Docker Stable Diffusion WebUI Forge

## Dockerized Stable Diffusion WebUI Forge

This repository provides a comprehensive Docker setup for running Stable Diffusion with a customized WebUI interface. The configuration has been optimized to support GPU acceleration via NVIDIA CUDA, ensuring high performance for generating AI-based images.

### Prerequisites

- **Docker** and **Docker Compose** installed on your system.
- **NVIDIA GPU** with driver support for CUDA (Version 12.7 recommended).
- **NVIDIA Container Toolkit** for GPU support within Docker.

### Project Overview

The repository is structured to build and deploy a Docker container that includes:

- CUDA 12.6.2 and cuDNN 8 for GPU acceleration.
- Python 3.10 as the runtime environment.
- PyTorch and other dependencies configured for stable operation.
- Options for persistent data storage, ensuring models and generated content are maintained across container restarts.
- Customizable launch arguments managed through the `webui-user.sh` script for flexibility.

### Setup and Installation

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/alex-des-santos/docker-stable-diffusion-webui-forge.git
   cd docker-stable-diffusion-webui-forge
   ```

2. **Docker Compose Configuration:**
   The `docker-compose.yml` file configures the build and runtime properties for the container:
   ```yaml
   services:
     stable-diffusion-webui:
       image: docker-forge-webui
       build:
         context: .
         dockerfile: Dockerfile
       ports:
         - "7860:7860"
       volumes:
         - ./data:/app/data
         - ./models:/app/models
       environment:
         - DEBIAN_FRONTEND=noninteractive
         - TZ=America/Sao_Paulo
       restart: always
       deploy:
         resources:
           reservations:
             devices:
               - driver: nvidia
                 count: 1
                 capabilities: [gpu]
   ```

3. **Building the Docker Image:**
   Build the Docker image using the provided `Dockerfile`:
   ```bash
   docker-compose build
   ```

4. **Running the Container:**
   Start the container with Docker Compose:
   ```bash
   docker-compose up -d
   ```

### Customization

#### Command-line Arguments

Custom arguments for the WebUI can be set in the `webui-user.sh` script:
```bash
#!/bin/bash
export COMMANDLINE_ARGS="--pin-shared-memory --xformers --cuda-malloc --listen"
```

### Troubleshooting

- **GPU Not Detected**: Ensure that the NVIDIA Container Toolkit is correctly installed, and the Docker Desktop settings allow for GPU usage.
- **Web Interface Not Accessible**: Confirm that the container is listening on `0.0.0.0` and check the mapped port (default `7860`).
- **Permission Issues**: Run the container as a non-root user if needed and set appropriate file permissions within the Docker setup.

### Useful Commands

- **Check Container Logs**:
   ```bash
   docker logs <container_id>
   ```
- **Access Container Shell**:
   ```bash
   docker exec -it <container_id> /bin/bash
   ```

### License

This project uses content from NVIDIA and other related packages that are governed by their respective licenses.

### Contributions

Feel free to submit pull requests or raise issues to improve this repository. 

### Author

Developed by [Alex dos Santos](https://github.com/alex-des-santos).

---

