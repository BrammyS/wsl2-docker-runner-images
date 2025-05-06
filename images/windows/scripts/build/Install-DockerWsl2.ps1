wsl --version
wsl --install Ubuntu

# Prevent WSL from closing immediately after running a command
wsl -d Ubuntu --exec dbus-launch true
wsl sudo apt-get update

# Add Docker repository to apt sources
wsl sudo apt-get install ca-certificates curl
wsl sudo install -m 0755 -d /etc/apt/keyrings
wsl sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
wsl sudo chmod a+r /etc/apt/keyrings/docker.asc
wsl sudo bash -c 'echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo ${UBUNTU_CODENAME:-$VERSION_CODENAME}) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null'
wsl sudo apt-get update
Start-Sleep 10

# Install Docker Engine, CLI, and Containerd
wsl sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
wsl docker info

# Expose Docker daemon to Windows
wsl bash -c "sudo sed -i 's|fd://|tcp://127.0.0.1:2375|' /usr/lib/systemd/system/docker.service"
wsl sudo systemctl daemon-reload
choco install docker-cli

# Use WSL2 docker daemon, set environment variables for Docker CLI
[Environment]::SetEnvironmentVariable('DOCKER_HOST', 'tcp://localhost:2375', 'Process')
[Environment]::SetEnvironmentVariable('DOCKER_HOST', 'tcp://localhost:2375', 'User')
[Environment]::SetEnvironmentVariable('DOCKER_HOST', 'tcp://localhost:2375', 'Machine')

# Verify Docker CLI is using WSL2 daemon
docker info
docker run --name test-hello-world hello-world:linux
docker rm test-hello-world
