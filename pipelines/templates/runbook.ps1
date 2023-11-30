# Define your variables
$resourceGroupName = "platform-mateusclira"
$automationAccountName = "testNewRunbook2"
$runbookName = "CopyDataRunbook2"
$sourceUrl = "https://devopsdaysrec.blob.core.windows.net/azcopy"
$destinationUrl = "https://azcopytestjeffii.blob.core.windows.net/?sv=2022-11-02&ss=bfqt&srt=sco&sp=rwdlacupiytfx&se=2023-11-10T01:53:00Z&st=2023-11-09T17:53:00Z&spr=https&sig=mmVheZCOVqO%2Bfg5mSz1DQNMEjGhWp%2B4IV%2FDMhehba%2Fw%3D"

# $userenv = (Get-ItemProperty -Path 'HKCU:\Environment' -Name Path).path
# $newPath = "$userenv;C:\Users\Admin\AppData\Local\Programs\AZCopy"
# $env:Path = $newPath

# Create automation account
az automation account create -g $resourceGroupName --name "testNewRunbook2" --location eastus --sku Basic

# Create PowerShell Workflow runbook
az automation runbook create -g $resourceGroupName --automation-account-name $automationAccountName --name $runbookName --type PowerShellWorkflow --location eastus

azcopy --version

az automation runbook update -g $resourceGroupName --automation-account-name $automationAccountName --name $runbookName

az automation runbook replace-content -g $resourceGroupName --automation-account-name $automationAccountName --name $runbookName --content "azcopy copy 'https://devopsdaysrec.blob.core.windows.net/azcopy' 'https://azcopytestjeffii.blob.core.windows.net/azcopytestupload?sp=racwdl&st=2023-11-10T18:32:40Z&se=2024-12-18T02:32:40Z&sv=2022-11-02&sr=c&sig=a%2BY4eSMhKiYqdRr9C%2BUyUVSzO0hQ1DmUkAaNu9n1WWA%3D' --recursive=true --overwrite=true"

# Publish the runbook
az automation runbook publish -g $resourceGroupName --automation-account-name $automationAccountName --name $runbookName

# Start the runbook
az automation runbook start -g $resourceGroupName --automation-account-name $automationAccountName --name $runbookName

# Schedule the runbook
az automation schedule create -g $resourceGroupName `
    --automation-account-name $automationAccountName `
    --name "DailySchedule" `
    --frequency "Day" `
    --interval "1" `
    --start-time "2023-11-10 18:52:00" `
    --time-zone "UTC+00:00"
