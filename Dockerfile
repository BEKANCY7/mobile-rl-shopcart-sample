# Reproducible Flutter test environment for the ShopCart RL sample.
FROM ghcr.io/cirruslabs/flutter:3.32.0

WORKDIR /workspace
COPY . /workspace

WORKDIR /workspace/app
RUN flutter pub get

WORKDIR /workspace
CMD ["./verify.sh"]
