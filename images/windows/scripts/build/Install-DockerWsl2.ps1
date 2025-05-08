Write-Host "Installing Docker for WSL2"
wsl --version
wsl --install Ubuntu-24.04

# Prevent WSL from closing immediately after running a command
wsl -d Ubuntu --exec dbus-launch true
wsl sudo apt-get update

Write-Host "Adding Docker repository to apt sources"
wsl sudo apt-get install ca-certificates curl
wsl sudo install -m 0755 -d /etc/apt/keyrings
wsl sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
wsl sudo chmod a+r /etc/apt/keyrings/docker.asc
wsl sudo bash -c "echo 'deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu noble stable' | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null"

Write-Host "Docker repository added to apt sources"
Start-Sleep 5
wsl sudo cat /etc/apt/sources.list.d/docker.list
wsl sudo apt-get update

Write-Host "Installing Docker Engine, CLI, and Containerd"
Start-Sleep 5
wsl sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
wsl docker info

Write-Host "Exposing Docker daemon to Windows"
wsl bash -c "sudo sed -i 's|fd://|tcp://127.0.0.1:2375|' /usr/lib/systemd/system/docker.service"
wsl sudo systemctl daemon-reload
choco install docker-cli

Write-Host "Setting environment variables for Docker CLI"
[Environment]::SetEnvironmentVariable('DOCKER_HOST', 'tcp://127.0.0.1:2375', 'Process')
[Environment]::SetEnvironmentVariable('DOCKER_HOST', 'tcp://127.0.0.1:2375', 'User')
[Environment]::SetEnvironmentVariable('DOCKER_HOST', 'tcp://127.0.0.1:2375', 'Machine')

Write-Host "Verifying Docker CLI is using WSL2 daemon"
docker info
docker run --name test-hello-world hello-world:linux
docker rm test-hello-world
