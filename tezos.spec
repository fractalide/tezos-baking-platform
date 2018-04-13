Name:		tezos
Version:	0.1
Release:	1%{?dist}
Summary:	tezos

Group:		crypto
License:	proprietary
URL:		https://www.tezos.com/

Source0: tezos-node
Source1: tezos-sandboxed-node.sh

BuildRequires: patchelf

Requires: glibc
Requires: gmp
Requires: libgcc
Requires: libstdc++
Requires: snappy
Requires: compat-openssl10
Requires: leveldb


%description

%prep

%build
# mkdir -p %{_builddir}
cp -p %{SOURCE0} ./tezos-node
cp -p %{SOURCE1} ./tezos-sandboxed-node.sh

# nix built stuff is "immutable"
chmod 755 ./tezos-node

 # $(basename $(rpm -ql compat-openssl10 | grep '/usr/lib64/libssl.so.1.0'))

patchelf --set-rpath %{_libdir} \
         --replace-needed libssl.so.1.0.0 libssl.so.10 \
         --replace-needed libcrypto.so.1.0.0 libcrypto.so.10 \
         --set-interpreter $(patchelf --print-interpreter $(which ld)) \
         ./tezos-node

ldd ./tezos-node

%install
mkdir -p ${RPM_BUILD_ROOT}/opt/tezos
cp -p %{_builddir}/tezos-node ${RPM_BUILD_ROOT}/opt/tezos/tezos-node
cp -p %{_builddir}/tezos-sandboxed-node.sh ${RPM_BUILD_ROOT}/opt/tezos/tezos-sandboxed-node.sh

%files

/opt/tezos/*

%changelog

