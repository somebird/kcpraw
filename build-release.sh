#!/bin/bash
SHA256='shasum -a 256'

VERSION=`date -u +%Y%m%d`
LDFLAGS="-X main.VERSION=$VERSION -s -w"
GCFLAGS=""

OSES=(linux darwin)
ARCHS=(amd64 386)
for os in ${OSES[@]}; do
	for arch in ${ARCHS[@]}; do
		suffix=""
		if [ "$os" == "windows" ]
		then
			suffix=".exe"
		fi
        cgo_enabled=1
        if [ "$os" == "linux" ]
        then 
            cgo_enabled=0
        fi 
        env CGO_ENABLED=$cgo_enabled GOOS=$os GOARCH=$arch go build -ldflags "$LDFLAGS" -gcflags "$GCFLAGS" -o kcpraw_client_${os}_${arch}${suffix} github.com/ccsexyz/kcpraw/client
        env CGO_ENABLED=$cgo_enabled GOOS=$os GOARCH=$arch go build -ldflags "$LDFLAGS" -gcflags "$GCFLAGS" -o kcpraw_server_${os}_${arch}${suffix} github.com/ccsexyz/kcpraw/server
		env CGO_ENABLED=$cgo_enabled GOOS=$os GOARCH=$arch go build -ldflags "$LDFLAGS" -gcflags "$GCFLAGS" -tags goprof -o kcpraw_client_${os}_${arch}${suffix}_pprof github.com/ccsexyz/kcpraw/client
        env CGO_ENABLED=$cgo_enabled GOOS=$os GOARCH=$arch go build -ldflags "$LDFLAGS" -gcflags "$GCFLAGS" -tags goprof -o kcpraw_server_${os}_${arch}${suffix}_pprof github.com/ccsexyz/kcpraw/server
		tar -zcf kcpraw-${os}-${arch}-$VERSION.tar.gz kcpraw_client_${os}_${arch}${suffix} kcpraw_server_${os}_${arch}${suffix} kcpraw_client_${os}_${arch}${suffix}_pprof kcpraw_server_${os}_${arch}${suffix}_pprof
		$SHA256 kcpraw-${os}-${arch}-$VERSION.tar.gz
	done
done

# ARM
ARMS=(5 6 7)
for v in ${ARMS[@]}; do
	env CGO_ENABLED=0 GOOS=linux GOARCH=arm GOARM=$v go build -ldflags "$LDFLAGS" -gcflags "$GCFLAGS" -o kcpraw_client_linux_arm$v  github.com/ccsexyz/kcpraw/client
	env CGO_ENABLED=0 GOOS=linux GOARCH=arm GOARM=$v go build -ldflags "$LDFLAGS" -gcflags "$GCFLAGS" -o kcpraw_server_linux_arm$v  github.com/ccsexyz/kcpraw/server
	env CGO_ENABLED=0 GOOS=linux GOARCH=arm GOARM=$v go build -ldflags "$LDFLAGS" -gcflags "$GCFLAGS" -tags goprof -o kcpraw_client_linux_arm${v}_pprof  github.com/ccsexyz/kcpraw/client
	env CGO_ENABLED=0 GOOS=linux GOARCH=arm GOARM=$v go build -ldflags "$LDFLAGS" -gcflags "$GCFLAGS" -tags goprof -o kcpraw_server_linux_arm${v}_pprof  github.com/ccsexyz/kcpraw/server
done
env CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -ldflags "$LDFLAGS" -gcflags "$GCFLAGS" -o kcpraw_client_linux_arm64 github.com/ccsexyz/kcpraw/client 
env CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -ldflags "$LDFLAGS" -gcflags "$GCFLAGS" -o kcpraw_server_linux_arm64 github.com/ccsexyz/kcpraw/server 
env CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -ldflags "$LDFLAGS" -gcflags "$GCFLAGS" -tags goprof -o kcpraw_client_linux_arm64_pprof github.com/ccsexyz/kcpraw/client 
env CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -ldflags "$LDFLAGS" -gcflags "$GCFLAGS" -tags goprof -o kcpraw_server_linux_arm64_pprof github.com/ccsexyz/kcpraw/server 
tar -zcf kcpraw-linux-arm-$VERSION.tar.gz kcpraw_client_linux_arm* kcpraw_server_linux_arm*
$SHA256 kcpraw-linux-arm-$VERSION.tar.gz

#MIPS32LE
env CGO_ENABLED=0 GOOS=linux GOARCH=mipsle go build -ldflags "$LDFLAGS" -gcflags "$GCFLAGS" -o kcpraw_client_linux_mipsle github.com/ccsexyz/kcpraw/client
env CGO_ENABLED=0 GOOS=linux GOARCH=mipsle go build -ldflags "$LDFLAGS" -gcflags "$GCFLAGS" -o kcpraw_server_linux_mipsle github.com/ccsexyz/kcpraw/server
env CGO_ENABLED=0 GOOS=linux GOARCH=mips go build -ldflags "$LDFLAGS" -gcflags "$GCFLAGS" -o kcpraw_client_linux_mips github.com/ccsexyz/kcpraw/client
env CGO_ENABLED=0 GOOS=linux GOARCH=mips go build -ldflags "$LDFLAGS" -gcflags "$GCFLAGS" -o kcpraw_server_linux_mips github.com/ccsexyz/kcpraw/server
env CGO_ENABLED=0 GOOS=linux GOARCH=mipsle go build -ldflags "$LDFLAGS" -gcflags "$GCFLAGS" -tags goprof -o kcpraw_client_linux_mipsle_pprof github.com/ccsexyz/kcpraw/client
env CGO_ENABLED=0 GOOS=linux GOARCH=mipsle go build -ldflags "$LDFLAGS" -gcflags "$GCFLAGS" -tags goprof -o kcpraw_server_linux_mipsle_pprof github.com/ccsexyz/kcpraw/server
env CGO_ENABLED=0 GOOS=linux GOARCH=mips go build -ldflags "$LDFLAGS" -gcflags "$GCFLAGS" -tags goprof -o kcpraw_client_linux_mips_pprof github.com/ccsexyz/kcpraw/client
env CGO_ENABLED=0 GOOS=linux GOARCH=mips go build -ldflags "$LDFLAGS" -gcflags "$GCFLAGS" -tags goprof -o kcpraw_server_linux_mips_pprof github.com/ccsexyz/kcpraw/server

tar -zcf kcpraw-linux-mipsle-$VERSION.tar.gz kcpraw_client_linux_mipsle kcpraw_client_linux_mipsle_pprof kcpraw_server_linux_mipsle kcpraw_server_linux_mipsle_pprof
tar -zcf kcpraw-linux-mips-$VERSION.tar.gz kcpraw_client_linux_mips kcpraw_server_linux_mips kcpraw_client_linux_mips_pprof kcpraw_server_linux_mips_pprof
$SHA256 kcpraw-linux-mipsle-$VERSION.tar.gz
$SHA256 kcpraw-linux-mips-$VERSION.tar.gz
