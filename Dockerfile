# Use slim Python base
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Install system deps (needed for torch & vLLM)
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install CPU-only PyTorch first
RUN pip install --no-cache-dir torch==2.2.2 --index-url https://download.pytorch.org/whl/cpu

# Install vLLM (CPU build only)
RUN pip install --no-cache-dir vllm==0.4.0.post1

# Expose Railway port
EXPOSE 8000

# Run vLLM API server, reading $PORT and $VLLM_API_KEY from env
CMD sh -c 'python -m vllm.entrypoints.openai.api_server \
    --model gpt2 \
    --device cpu \
    --dtype float32 \
    --host 0.0.0.0 \
    --port $PORT \
    --api-key $VLLM_API_KEY'

