#!/bin/sh
set -e

# This script generates packages for a release and places them in target/packages

cargo fmt -- --check
cargo clippy --all
cargo test

VERSION=$(cargo pkgid | sed 's/.*#//')
PKG_DIR=target/packages
mkdir -p $PKG_DIR

cargo deb
cp target/debian/*.deb $PKG_DIR

cargo rpm build
cp target/release/rpmbuild/RPMS/x86_64/*.rpm $PKG_DIR

cargo build --release --target=x86_64-pc-windows-gnu
zip -j $PKG_DIR/"fclones-$VERSION-win.x86_64.zip" target/x86_64-pc-windows-gnu/release/fclones.exe

cargo build --release --target=aarch64-unknown-linux-gnu
zip -j $PKG_DIR/"fclones-$VERSION-linux.aarch64.zip" target/aarch64-unknown-linux-gnu/release/fclones

cargo build --release --target=armv7-unknown-linux-gnueabihf
zip -j $PKG_DIR/"fclones-$VERSION-linux.armv7.zip" target/armv7-unknown-linux-gnueabihf/release/fclones
