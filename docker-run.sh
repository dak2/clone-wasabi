#!/bin/bash

# Function to display help
show_help() {
    echo "Usage: $0 [OPTION]"
    echo "Build and run Clone WasabiOS in Docker."
    echo ""
    echo "Options:"
    echo "  -h, --help      Show this help message"
    echo "  -b, --build     Build the Docker image"
    echo "  -s, --shell     Start a shell in the container"
    echo "  -r, --run       Build and run Clone WasabiOS"
    echo ""
    echo "If no option is provided, it will build the image and start a shell."
}

# Function to build the Docker image
build_image() {
    echo "Building Docker image..."
    docker-compose build
}

# Function to start a shell in the container
start_shell() {
    echo "Starting container and shell..."
    docker-compose up -d
    docker-compose exec clone-wasabi bash
}

# Function to build and run Clone WasabiOS
build_and_run() {
    echo "Building and running Clone WasabiOS..."
    docker-compose up -d
    docker-compose exec clone-wasabi bash -c "cargo +nightly-2024-01-01 build && ./scripts/launch_qemu.sh target/x86_64-unknown-linux-gnu/debug/clone-wasabi"
}

# Check if X11 is available
check_x11() {
    if [ -z "$DISPLAY" ]; then
        echo "Warning: DISPLAY environment variable is not set."
        echo "X11 forwarding may not work correctly."
        echo "See README.docker.md for instructions on setting up X11 forwarding."
    fi
}

# Main script
if [ $# -eq 0 ]; then
    build_image
    check_x11
    start_shell
else
    case "$1" in
        -h|--help)
            show_help
            ;;
        -b|--build)
            build_image
            ;;
        -s|--shell)
            check_x11
            start_shell
            ;;
        -r|--run)
            check_x11
            build_and_run
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
fi
