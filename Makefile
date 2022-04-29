SHELL := /bin/bash
PACKAGE_NAME:=$(shell cargo get -n)

.PHONY: all

all: build 


build:
	cargo build --release
	cargo fmt --all
	cargo fmt --all -- --check
	ls -sh target/release/$(PACKAGE_NAME)
	cp target/release/$(PACKAGE_NAME) target/$(PACKAGE_NAME)

build-upx:
	ls -sh target/release/$(PACKAGE_NAME)
	upx --best --lzma target/release/$(PACKAGE_NAME) target/$(PACKAGE_NAME)
	ls -sh target/release/$(PACKAGE_NAME) target/$(PACKAGE_NAME)


install-upx:
	curl -skLO https://github.com/upx/upx/releases/download/v3.96/upx-3.96-amd64_linux.tar.xz
	tar -xf upx-3.9*-amd64_linux.tar.xz
	cp upx-3.9*-amd64_linux/upx /usr/local/bin/
	chmod +x /usr/local/bin/upx
	rm -rf upx-3.9*


install-rust: 
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	source $HOME/.profile


install-plugins: 
	cargo install cargo-get
	cargo install cargo-edit
	rustup target add x86_64-pc-windows-gnu
	rustup target add x86_64-apple-darwin
	rustup target add x86_64-unknown-linux-musl
	#sudo apt-get install -y musl-tools mingw-w64
