
Name:		tezos
Version:	0.1
Release:	1%{?dist}
Summary:	tezos

Group:		crypto
License:	proprietary
URL:		https://www.tezos.com/

ExclusiveArch: x86_64

Source0: ./tezos-prebuilt.tar

BuildRequires: patchelf

Requires: glibc
Requires: gmp
Requires: libgcc
Requires: libstdc++
Requires: snappy
Requires: compat-openssl10
Requires: leveldb


%description


%build
%prep
%setup -n tezos

# nix built stuff is "immutable"
chmod 755 ./tezos-node
patchelf --set-rpath "%{_libdir}" \
         --replace-needed libssl.so.1.0.0 libssl.so.10 \
         --replace-needed libcrypto.so.1.0.0 libcrypto.so.10 \
         --set-interpreter "$(patchelf --print-interpreter "%{__ld}")" \
         ./tezos-node

chmod 755 ./tezos-client
patchelf --set-rpath "%{_libdir}" \
         --replace-needed libssl.so.1.0.0 libssl.so.10 \
         --replace-needed libcrypto.so.1.0.0 libcrypto.so.10 \
         --set-interpreter "$(patchelf --print-interpreter "%{__ld}")" \
         ./tezos-client

chmod 755 ./tezos-admin-client
patchelf --set-rpath "%{_libdir}" \
         --replace-needed libssl.so.1.0.0 libssl.so.10 \
         --replace-needed libcrypto.so.1.0.0 libcrypto.so.10 \
         --set-interpreter "$(patchelf --print-interpreter "%{__ld}")" \
         ./tezos-admin-client

chmod 755 ./tezos-baker-alpha
patchelf --set-rpath "%{_libdir}" \
         --replace-needed libssl.so.1.0.0 libssl.so.10 \
         --replace-needed libcrypto.so.1.0.0 libcrypto.so.10 \
         --set-interpreter "$(patchelf --print-interpreter "%{__ld}")" \
         ./tezos-baker-alpha

# patchbash?
sed -i '1s@#![[:space:]]*/nix/store/[^/]*/bin@%{_bindir}@' ./tezos-sandboxed-node.sh

# ldd ./tezos-node
# head ./tezos-sandboxed-node.sh

%install
mkdir -p ${RPM_BUILD_ROOT}/opt/tezos/bin
cp -p %{_builddir}/tezos/tezos-node ${RPM_BUILD_ROOT}/opt/tezos/bin/tezos-node
cp -p %{_builddir}/tezos/tezos-client ${RPM_BUILD_ROOT}/opt/tezos/bin/tezos-client
cp -p %{_builddir}/tezos/tezos-admin-client ${RPM_BUILD_ROOT}/opt/tezos/bin/tezos-admin-client
cp -p %{_builddir}/tezos/tezos-baker-alpha ${RPM_BUILD_ROOT}/opt/tezos/bin/tezos-baker-alpha
cp -p %{_builddir}/tezos/tezos-sandboxed-node.sh ${RPM_BUILD_ROOT}/opt/tezos/bin/tezos-sandboxed-node.sh

%files

/opt/tezos/*

%changelog

