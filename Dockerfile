FROM decentralize/comfyui:latest

# Install git (needed by some pip installs)
RUN apt-get update && apt-get install -y git

# Install SVD-xt and InstantID via pip from GitHub (public HTTPS, no auth)
RUN python3 -m pip install \
    git+https://github.com/thecooltechguy/ComfyUI-Stable-Video-Diffusion.git \
    git+https://github.com/huxiuhan/ComfyUI-InstantID.git

WORKDIR /workspace/ComfyUI
ENTRYPOINT ["python3", "main.py", "--listen", "--port", "8080"]
