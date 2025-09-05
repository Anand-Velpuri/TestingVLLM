# Use slim Python base
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install the specific CPU-only PyTorch version that vLLM needs
RUN pip install --no-cache-dir torch==2.1.2 --index-url https://download.pytorch.org/whl/cpu

# FIX: Install a compatible version of NumPy before installing vLLM
RUN pip install --no-cache-dir "numpy<2.0"

# Install vLLM (it will now use the correct NumPy version)
RUN pip install --no-cache-dir --prefer-binary vllm==0.4.0.post1

# Expose Railway port
EXPOSE 8000

# Run vLLM API server
CMD sh -c 'python -m vllm.entrypoints.openai.api_server \
    --model gpt2 \
    --device cpu \
    --dtype float32 \
    --host 0.0.0.0 \
    --port $PORT \
    --api-key $VLLM_API_KEY'
