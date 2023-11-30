# Define your variables
resourceGroupName="platform-mateusclira"
automationAccountName="testNewRunbook"
runbookName="CopyDataRunbook"
sourceUrl="https://devopsdaysrec.blob.core.windows.net/azcopy"
destinationUrl="https://azcopytestjeffii.blob.core.windows.net/?sv=2022-11-02&ss=bfqt&srt=sco&sp=rwdlacupiytfx&se=2023-11-10T01:53:00Z&st=2023-11-09T17:53:00Z&spr=https&sig=mmVheZCOVqO%2Bfg5mSz1DQNMEjGhWp%2B4IV%2FDMhehba%2Fw%3D"

az automation account create -g "platform-mateusclira" --name "testNewRunbook2" --location eastus --sku Basic

az automation runbook create  -g "platform-mateusclira" --automation-account-name "testNewRunbook2" --name "CopyDataRunbook2" --type PowerShellWorkflow --location eastus

az automation runbook replace-content -g "platform-mateusclira" --automation-account-name "testNewRunbook2" --name "CopyDataRunbook2" --content script.ps1

az automation runbook publish -g "platform-mateusclira" --automation-account-name "testNewRunbook2" --name "CopyDataRunbook2"

az automation runbook start -g "platform-mateusclira" --automation-account-name "testNewRunbook2"  --name "CopyDataRunbook2"

# Schedule the runbook
az automation schedule create -g "platform-mateusclira" \
    --automation-account-name "testNewRunbook2" \
    --name "DailySchedule" \
    --frequency "Day" \
    --interval "1" \
    --start-time "2023-11-10 18:52:00" \
    --time-zone "UTC+00:00" \
