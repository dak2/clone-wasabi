FROM --platform=linux/x86_64 debian:bookworm

# Set non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    qemu-system-x86 \
    qemu-utils \
    netcat-openbsd \
    clang \
    llvm \
    lld \
    sudo \
    zsh \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Install Rust as the non-root user
USER $USERNAME
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Add cargo to PATH
ENV PATH="/home/$USERNAME/.cargo/bin:${PATH}"

RUN rustup toolchain install nightly-2024-01-01 && \
    rustup component add rustfmt rust-src --toolchain nightly-2024-01-01 && \
    rustup target add x86_64-unknown-linux-gnu --toolchain nightly-2024-01-01

# Set working directory
WORKDIR /clone-wasabi

# Switch back to root for any remaining setup
USER root

# Keep container running
CMD ["sleep", "infinity"]
