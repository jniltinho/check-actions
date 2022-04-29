# check-actions
Check Actions and on Github API


# Install Rust on Linux

```bash
sudo apt-get update
sudo apt-get install curl git gcc xz-utils
cd $HOME
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> $HOME/.profile
source $HOME/.profile
```

## Run check-actions

```bash
git clone https://github.com/jniltinho/check-actions.git
cd check-actions
cargo install cargo-get
make build
target/release/check-actions --set-username=jniltinho
target/release/check-actions -h
target/release/check-actions -V
```

## Run UPX on Rust binary

```bash
curl -LO https://github.com/upx/upx/releases/download/v3.96/upx-3.96-amd64_linux.tar.xz
tar -xf upx-3.96-amd64_linux.tar.xz
cp upx-3.96-amd64_linux/upx /usr/local/bin/
rm -rf upx-3.96-*
ls -sh target/release/check-actions
upx --best --lzma target/release/check-actions
ls -sh target/release/check-actions
target/release/check-actions --help
```


## Links

* https://tech.fpcomplete.com/rust/command-line-parsing-clap
* https://www.rust-lang.org/tools/install
* https://crates.io/crates/cmd_lib
* https://github.com/rust-shell-script/rust_cmd_lib
* https://github.com/rust-embedded/cross
