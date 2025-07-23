FROM --platform=linux/x86_64 debian:bookworm

# Set non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Debian version: 12.10, apt version: 2.6.1

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    qemu-system-x86 \
    libgtk-3-0 \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    libegl1-mesa \
    libglvnd0 \
    libgles2 \
    mesa-utils \
    netcat-openbsd \
    clang \
    llvm \
    lld \
    && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Add cargo to PATH
ENV PATH="/root/.cargo/bin:${PATH}"

# Set up the specific nightly toolchain required by the project
RUN rustup toolchain install nightly-2024-01-01 && \
    rustup component add rustfmt rust-src --toolchain nightly-2024-01-01 && \
    rustup target add x86_64-unknown-linux-gnu --toolchain nightly-2024-01-01

# Create working directory
WORKDIR /clone-wasabi

# Copy the project files
COPY . .

# Build the project (commented out as it might be better to run this manually)
# RUN cargo +nightly-2024-01-01 build

# Set the default command to build and run the project
CMD ["bash", "-c", "cargo +nightly-2024-01-01 build && ./scripts/launch_qemu.sh target/x86_64-unknown-linux-gnu/debug/clone-wasabi"]
