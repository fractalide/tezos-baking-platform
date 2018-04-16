
Name:		tezos
Version:	0.1
Release:	1%{?dist}
Summary:	tezos

Group:		crypto
License:	proprietary
URL:		https://www.tezos.com/

ExclusiveArch: x86_64

Source0: ./tezos-prebuilt.tar
# Source1: tezos-node
# Source2: tezos-sandboxed-node.sh

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
# mkdir -p %{_builddir}
find .
# cp -p %{SOURCE1} ./tezos-node
# cp -p %{SOURCE2} ./tezos-sandboxed-node.sh

pwd

# nix built stuff is "immutable"
chmod 755 ./tezos-node


 # $(basename $(rpm -ql compat-openssl10 | grep '/usr/lib64/libssl.so.1.0'))

patchelf --set-rpath "%{_libdir}" \
         --replace-needed libssl.so.1.0.0 libssl.so.10 \
         --replace-needed libcrypto.so.1.0.0 libcrypto.so.10 \
         --set-interpreter "$(patchelf --print-interpreter "%{_ld}")" \
         ./tezos-node

ldd ./tezos-node

%install
mkdir -p ${RPM_BUILD_ROOT}/opt/tezos
cp -p %{_builddir}/tezos/tezos-node ${RPM_BUILD_ROOT}/opt/tezos/tezos-node
cp -p %{_builddir}/tezos/tezos-sandboxed-node.sh ${RPM_BUILD_ROOT}/opt/tezos/tezos-sandboxed-node.sh

%files

/opt/tezos/*

%changelog

