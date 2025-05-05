FROM decentralize/comfyui:latest

# Install git
RUN apt-get update && apt-get install -y git

# Install SVD-xt node
RUN git clone --depth 1 \
    https://github.com/thecooltechguy/ComfyUI-Stable-Video-Diffusion.git \
    /workspace/ComfyUI/custom_nodes/ComfyUI-Stable-Video-Diffusion

# Install InstantID node
RUN git clone --depth 1 \
    https://github.com/huxiuhan/ComfyUI-InstantID.git \
    /workspace/ComfyUI/custom_nodes/comfyui_instantid

# (Optional) LoRA-Inject can be added later via the Manager UI
# RUN git clone --depth 1 \
#     https://github.com/kohya-ss/comfyui-lora-inject.git \
#     /workspace/ComfyUI/custom_nodes/comfyui_lora_inject

# Build the SVD-xt CUDA kernels
RUN cd /workspace/ComfyUI/custom_nodes/ComfyUI-Stable-Video-Diffusion \
 && python3 setup.py install

WORKDIR /workspace/ComfyUI
ENTRYPOINT ["python3", "main.py", "--listen", "--port", "8080"]
