[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 

Invoke-WebRequest -Uri "https://aka.ms/downloadazcopy-v10-windows" -OutFile AzCopy.zip -UseBasicParsing
Expand-Archive -Path ./AzCopy.zip -Destination ./AzCopy -Force

mkdir C:\AZCopy
Get-ChildItem ./AzCopy/*/azcopy.exe | Move-Item -Destination C:\AZCopy -Force

$userenv = (Get-ItemProperty -Path 'HKCU:\Environment' -Name Path).path
$newPath = "$userenv;C:\AZCopy;"
New-ItemProperty -Path 'HKCU:\Environment' -Name Path -Value $newPath -Force

# $env:Path = [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User) + $newPath

# Restart PowerShell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "runbook.ps1"
