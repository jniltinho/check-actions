SHELL := /bin/bash
PACKAGE_NAME:=$(shell cargo get -n)

.PHONY: all

all: build 


build:
	cargo build --release
	cargo fmt --all


build-win:
	cargo build --release --target x86_64-pc-windows-gnu


build-mac:
	sed -i 's|strip=true|#strip=true|' Cargo.toml
	build-mac-release
	sed -i 's|#strip=true|strip=true|' Cargo.toml

run-upx:
	ls -sh target/release/$(PACKAGE_NAME)
	upx --best --lzma target/release/$(PACKAGE_NAME)
	upx --best --lzma target/x86_64-pc-windows-gnu/release/$(PACKAGE_NAME).exe
	upx --best --lzma target/x86_64-apple-darwin/release/$(PACKAGE_NAME)


create-tar:
	rm -f *.tar.gz
	cp target/release/$(PACKAGE_NAME) .
	tar -zcf $(PACKAGE_NAME)-linux64.tar.gz $(PACKAGE_NAME)
	rm -f $(PACKAGE_NAME)
	cp target/x86_64-pc-windows-gnu/release/$(PACKAGE_NAME).exe .
	tar -zcf $(PACKAGE_NAME)-win64.tar.gz $(PACKAGE_NAME).exe
	cp target/x86_64-apple-darwin/release/$(PACKAGE_NAME) .
	tar -zcf $(PACKAGE_NAME)-mac64.tar.gz $(PACKAGE_NAME)
	rm -f $(PACKAGE_NAME).exe $(PACKAGE_NAME)
	ls -ilah *.tar.gz

clean:
	rm -f *.tar.gz
	rm -rf target
	rm -f $(PACKAGE_NAME) $(PACKAGE_NAME).exe


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
