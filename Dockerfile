# Use PyTorch CPU image (already has torch preinstalled)
FROM pytorch/pytorch:2.3.0-cpu-py3.10

# Set working directory
WORKDIR /app

# Install vLLM (CPU build)
RUN pip install --no-cache-dir vllm==0.4.0.post1

# Expose port
EXPOSE 8000

# Run vLLM API server
CMD ["python", "-m", "vllm.entrypoints.openai.api_server", \
     "--model", "gpt2", \
     "--device", "cpu", \
     "--dtype", "float32", \
     "--host", "0.0.0.0", \
     "--port", "8000", \
     "--api-key", "${VLLM_API_KEY}"]
