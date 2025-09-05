FROM python:3.10-slim

WORKDIR /app

# Install vLLM + dependencies
RUN pip install --no-cache-dir vllm==0.4.0.post1

# Expose Railway's dynamic port
EXPOSE $PORT

# Run vLLM API server in CPU mode with GPT-2
CMD ["sh", "-c", "python -m vllm.entrypoints.openai.api_server \
     --model gpt2 \
     --device cpu \
     --dtype float32 \
     --host 0.0.0.0 \
     --port $PORT"]
