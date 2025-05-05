FROM decentralize/comfyui:latest

# Install git
RUN apt-get update && apt-get install -y git

# Add community nodes
RUN mkdir -p /workspace/ComfyUI/custom_nodes && \
    git clone https://github.com/thecooltechguy/ComfyUI-Stable-Video-Diffusion.git \
      /workspace/ComfyUI/custom_nodes/ComfyUI-Stable-Video-Diffusion && \
    git clone https://github.com/comfyanonymous/ComfyUI-InstantID.git \
      /workspace/ComfyUI/custom_nodes/comfyui_instantid && \
    git clone https://github.com/kohya-ss/comfyui-lora-inject.git \
      /workspace/ComfyUI/custom_nodes/comfyui_lora_inject

# Recompile Triton for broad GPU support
ENV TORCH_CUDA_ARCH_LIST="7.5;8.0;8.6;8.9;12.0"
RUN pip uninstall -y triton && pip install --force-reinstall triton

# Build SVD-xt kernels
RUN cd /workspace/ComfyUI/custom_nodes/ComfyUI-Stable-Video-Diffusion && \
    python setup.py install

WORKDIR /workspace/ComfyUI
ENTRYPOINT ["python", "main.py", "--listen", "--port", "8080"]
