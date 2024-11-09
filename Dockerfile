# Base image com CUDA 12.1 e cuDNN 8
FROM nvidia/cuda:12.6.2-cudnn-runtime-ubuntu22.04

# Definir variáveis de ambiente para evitar prompts interativos
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Sao_Paulo

# Atualizar repositórios e instalar dependências
RUN apt-get update && apt-get install -y \
    software-properties-common \
    ca-certificates \
    wget \
    curl \
    git \
    libgl1-mesa-glx \
    dos2unix && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y \
    python3.10 \
    python3.10-venv \
    python3.10-dev \
    python3.10-distutils \
    python3-pip \
    tzdata && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Instalar google-perftools sem recomendações
RUN apt-get update && apt-get install -y --no-install-recommends google-perftools && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Atualizar pip e setuptools
RUN python3.10 -m pip install --upgrade pip setuptools

# Criar um usuário não-root
RUN useradd -m nonrootuser

# Definir o diretório de trabalho e ajustar permissões
WORKDIR /app
COPY . .

# Ajustar permissões para evitar problemas de acesso
RUN chown -R nonrootuser:nonrootuser /app && chmod -R 755 /app

# Converter os arquivos para o formato Unix
RUN dos2unix /app/webui.sh /app/webui-user.sh

# Tornar o script executável
RUN chmod +x /app/webui.sh

# Instalar PyTorch diretamente com tentativas de repetição
RUN bash -c 'for i in {1..5}; do python3.10 -m pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121 --no-cache-dir && break || echo "Retrying in 5 seconds..." && sleep 5; done'

# Executar o script webui.sh durante a build para pré-configuração
RUN bash /app/webui.sh || echo "webui.sh execution completed with non-fatal issues during build."

# Mudar para o usuário não-root
USER nonrootuser