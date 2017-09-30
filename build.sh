#! /usr/bin/env bash

if [ "$(uname)" == "Darwin" ]; then
    curl -o dotnet-sdk-2.0.0-osx-gs-x64.pkg -k https://download.microsoft.com/download/0/F/D/0FD852A4-7EA1-4E2A-983A-0484AC19B92C/dotnet-sdk-2.0.0-osx-gs-x64.pkg
    sudo installer -pkg dotnet-sdk-2.0.0-osx-gs-x64.pkg -target $PWD
    export PATH=$PATH:$PWD/usr/local/share/dotnet/
else
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-trusty-prod trusty main" > /etc/apt/sources.list.d/dotnetdev.list'
    sudo apt-get update
    sudo apt-get install dotnet-sdk-2.0.0
fi

dotnet restore

if [ -z ${MONO_BUILD+x} ]; then
    # Build with dotnet
    dotnet build Grpc.Tools.MsBuild.sln -v normal
else
    # Build with Mono
    msbuild
fi
