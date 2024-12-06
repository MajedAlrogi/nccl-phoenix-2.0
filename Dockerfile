# Base image with CUDA
FROM nvidia/cuda:12.0.0-devel-ubuntu22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    devscripts \
    debhelper \
    fakeroot \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /workspace

# Clone NCCL repository
RUN git clone https://github.com/NVIDIA/nccl.git

# Build NCCL
WORKDIR /workspace/nccl
RUN make -j src.build NVCC_GENCODE="-gencode=arch=compute_70,code=sm_70"

# Create Debian package
RUN make pkg.debian.build

# Create a directory to store the built artifacts
RUN mkdir -p /output
RUN cp build/pkg/deb/* /output/

# Create volume mount point
VOLUME /phoenix-nccl

# Copy built packages to the volume
CMD cp -r /output/* /project/