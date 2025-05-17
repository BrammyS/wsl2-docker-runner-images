Describe "Docker is running" {
    It "docker is installed" {
        "docker --version" | Should -ReturnZeroExitCode
    }

    it "wsl should start up" {
        wsl -d Ubuntu --exec dbus-launch true
        wsl sudo systemctl restart docker | Should -ReturnZeroExitCode
        wsl sudo systemctl status docker | Should -ReturnZeroExitCode
    }

    It "docker service is up" {
        "docker images" | Should -ReturnZeroExitCode
    }

    It "docker can run linux containers" {
        docker run --name test-hello-world hello-world:linux | Should -ReturnZeroExitCode
    }
}

Describe "Docker" -Skip:(Test-IsWin25) {
    It "docker is installed" {
        "docker --version" | Should -ReturnZeroExitCode
    }

    It "docker service is up" {
        "docker images" | Should -ReturnZeroExitCode
    }

    It "docker symlink" {
        "C:\Windows\SysWOW64\docker.exe ps" | Should -ReturnZeroExitCode
    }
}

Describe "DockerCompose" -Skip:(Test-IsWin25) {
    It "docker compose v2" {
        "docker compose version" | Should -ReturnZeroExitCode
    }

}

Describe "DockerWinCred" -Skip:(Test-IsWin25) {
    It "docker-wincred" {
        "docker-credential-wincred version" | Should -ReturnZeroExitCode
    }
}

Describe "DockerImages" -Skip:(Test-IsWin25) {
    Context "docker images" {
        $testCases = (Get-ToolsetContent).docker.images | ForEach-Object { @{ ImageName = $_ } }

        It "<ImageName>" -TestCases $testCases {
            docker images "$ImageName" --format "{{.Repository}}" | Should -Not -BeNullOrEmpty
        }
    }
}
