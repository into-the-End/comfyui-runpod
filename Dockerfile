FROM decentralize/comfyui:latest

# install git
RUN apt-get update && apt-get install -y git

# install SVD-xt nodes
RUN git clone --depth 1 \
    https://github.com/thecooltechguy/ComfyUI-Stable-Video-Diffusion.git \
    /workspace/ComfyUI/custom_nodes/ComfyUI-Stable-Video-Diffusion

# Install InstantID nodes
RUN git clone --depth 1 \
    https://github.com/huxiuhan/ComfyUI-InstantID.git \
    /workspace/ComfyUI/custom_nodes/comfyui_instantid

# (temporarily skip the LoRA-Inject clone—let’s leave that to the Manager UI for now)
# RUN git clone --depth 1 \
#     https://github.com/kohya-ss/comfyui-lora-inject.git \
#     /workspace/ComfyUI/custom_nodes/comfyui_lora_inject

# recompile Triton
ENV TORCH_CUDA_ARCH_LIST="7.5;8.0;8.6;8.9;12.0"
RUN pip uninstall -y triton && pip install --force-reinstall triton

# build the SVD kernels
RUN cd /workspace/ComfyUI/custom_nodes/ComfyUI-Stable-Video-Diffusion && \
    python setup.py install

WORKDIR /workspace/ComfyUI
ENTRYPOINT ["python", "main.py", "--listen", "--port", "8080"]
