# Use PyTorch CPU image (already has torch preinstalled)
FROM pytorch/pytorch:2.3.0-cpu

# Set working directory
WORKDIR /app

# Install vLLM (CPU only)
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir vllm==0.4.0.post1

# Expose Railway port
EXPOSE 8000

# Run vLLM API server in CPU mode with GPT-2
# Use $PORT (Railway sets this env var automatically)
CMD ["python", "-m", "vllm.entrypoints.openai.api_server", \
     "--model", "gpt2", \
     "--device", "cpu", \
     "--dtype", "float32", \
     "--host", "0.0.0.0", \
     "--port", "$PORT", \
     "--api-key", "${VLLM_API_KEY}"]

