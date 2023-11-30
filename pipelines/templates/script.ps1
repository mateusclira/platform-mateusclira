# Download and extract
Invoke-WebRequest -Uri "https://aka.ms/downloadazcopy-v10-windows" -OutFile AzCopy.zip -UseBasicParsing
Expand-Archive ./AzCopy.zip ./AzCopy -Force
# Get-PSRepository
# Install-Module -Name AzCopy -Force -AllowClobber
# Install-Module -Path "C:\Path\To\Downloaded\Module.zip" -Force -AllowClobber

# $env:Path = [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User)
# Move AzCopy
mkdir ~\AppData\Local\Programs\AZCopy
Get-ChildItem ./AzCopy/*/azcopy.exe | Move-Item -Destination ~\AppData\Local\Programs\AZCopy\

# HKCU is HKEY_CURRENT_USER
# Add AzCopy to PATH
$userenv = (Get-ItemProperty -Path 'HKCU:\Environment' -Name Path).path
$newPath = "$userenv;%USERPROFILE%\AppData\Local\Programs\AZCopy;"
New-ItemProperty -Path 'HKCU:\Environment' -Name Path -Value $newPath -Force

#close terminal first


# Start a new PowerShell session to pick up the updated PATH
$env:Path = [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User)

# Wait for a moment to let the environment variables update
Start-Sleep -Seconds 5

azcopy copy 'https://devopsdaysrec.blob.core.windows.net/azcopy' 'https://azcopytestjeffii.blob.core.windows.net/azcopytestupload?sp=racwdl&st=2023-11-10T18:32:40Z&se=2024-12-18T02:32:40Z&sv=2022-11-02&sr=c&sig=a%2BY4eSMhKiYqdRr9C%2BUyUVSzO0hQ1DmUkAaNu9n1WWA%3D' --recursive=true --overwrite=true