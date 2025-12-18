# ===== BUILD STAGE =====
# Use Alpine for compiling (smaller than full Ubuntu, but has build tools)
FROM alpine:latest AS builder

# Install only build dependencies
RUN apk add --no-cache \
    git \
    build-base \
    cmake \
    libusb-dev

# Build rtl-sdr from source
WORKDIR /tmp
RUN git clone https://gitea.osmocom.org/sdr/rtl-sdr.git && \
    mkdir -p rtl-sdr/build && \
    cd rtl-sdr/build && \
    cmake -DDETACH_KERNEL_DRIVER=ON .. && \
    make && \
    make install && \
    ldconfig || true

# ===== RUNTIME STAGE =====
# Use minimal Alpine for running (no build tools needed)
FROM alpine:latest

# Install only runtime dependencies (libusb for USB access)
RUN apk add --no-cache libusb

# Copy compiled binaries and libraries from builder stage
COPY --from=builder /usr/local/bin/rtl_* /usr/local/bin/
COPY --from=builder /usr/local/lib/librtl* /usr/local/lib/

# Refresh library cache
RUN ldconfig || true

# Labels for Docker Hub documentation
LABEL maintainer="N9SLA"
LABEL description="RTL-SDR rtl_tcp server for remote SDR access"
LABEL version="1.0.0"

# Document the exposed port
EXPOSE 1234

# Health check (optional but recommended)
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD ps aux | grep -v grep | grep rtl_tcp || exit 1

# Run rtl_tcp listening on all interfaces
ENTRYPOINT ["rtl_tcp", "-a", "0.0.0.0", "-p", "1234"]

