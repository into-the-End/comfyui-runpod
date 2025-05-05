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

# (Optional) LoRA-Inject can be added later via ComfyUI Manager
# RUN git clone --depth 1 \
#     https://github.com/kohya-ss/comfyui-lora-inject.git \
#     /workspace/ComfyUI/custom_nodes/comfyui_lora_inject

# Recompile Triton for broad GPU support
ENV TORCH_CUDA_ARCH_LIST="7.5;8.0;8.6;8.9;12.0"
RUN python3 -m pip uninstall -y triton \
 && python3 -m pip install --force-reinstall triton

# Build the SVD-xt CUDA kernels
RUN cd /workspace/ComfyUI/custom_nodes/ComfyUI-Stable-Video-Diffusion \
 && python setup.py install

WORKDIR /workspace/ComfyUI
ENTRYPOINT ["python", "main.py", "--listen", "--port", "8080"]
