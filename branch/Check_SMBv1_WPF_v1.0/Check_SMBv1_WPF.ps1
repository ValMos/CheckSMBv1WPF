# This part was taken on
# Придумано не мной, взято здесь
# http://www.workingsysadmin.com/open-file-dialog-box-in-powershell/
# Thanx to Thomas Rayner, who posted this

function Get-FileName ($initialDirectory) {
    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null

    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.InitialDirectory = $initialDirectory
    $OpenFileDialog.Filter = "Text file (*.txt)| *.txt"
    $OpenFileDialog.Title = "Choose file with PCs names for check updates"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.FileName
}

$WPFform_InputData = Get-FileName "$env:USERPROFILE\Desktop"
$ComputersList = Get-Content $WPFform_InputData

####### Проверка на наличие обновлений для SMBv1 #######
####### Check patches for SMBv1 #######
# Список патчей был в сообщении в Telegram группе по SCCM, автора не запомнил, к сожалению
# Проверяем версию ОС для выбора правильного списка патчей
# Check OS version for choose correct patches list
ForEach ($CurrentPC in $ComputersList) {
    $Local:CurrentPC_OSVersion = (Get-WmiObject -Class Win32_OperatingSystem -ComputerName $CurrentPC).Version

        # Windows 7, 2008R2
        If ($CurrentPC_OSVersion -like "6.1*") {
            Get-WmiObject -Class Win32_QuickFixEngineering -ComputerName $CurrentPC |
            Where-Object {
                $_.HotFixID -eq 'KB4012212' -or
                $_.HotFixID -eq 'KB4012215' -or
                $_.HotFixID -eq 'KB4015549' -or
                $_.HotFixID -eq 'KB4019264' -or
                $_.HotFixID -eq 'KB4015552'
            } |
            Format-Table -AutoSize -HideTableHeaders
        }
        # Windows 8.1, 2012R2
        ElseIf ($CurrentPC_OSVersion -like "6.3*") {
            Get-WmiObject -Class Win32_QuickFixEngineering -ComputerName $CurrentPC |
            Where-Object {
                $_.HotFixID -eq 'KB4012213' -or
                $_.HotFixID -eq 'KB4012216' -or
                $_.HotFixID -eq 'KB4015550' -or
                $_.HotFixID -eq 'KB4019215' -or
                $_.HotFixID -eq 'KB4015553'
            } |
            Format-Table -AutoSize -HideTableHeaders
        }
        # Windows XP
        ElseIf ($CurrentPC_OSVersion -like "5.1*") {
            Get-WmiObject -Class Win32_QuickFixEngineering -ComputerName $CurrentPC |
            Where-Object {
                $_.HotFixID -eq 'KB4012598'
            } |
            Format-Table -AutoSize -HideTableHeaders
        }
        # Windows 2003
        ElseIf ($CurrentPC_OSVersion -like "5.2*") {
            Get-WmiObject -Class Win32_QuickFixEngineering -ComputerName $CurrentPC |
            Where-Object {
                $_.HotFixID -eq 'KB4012598'
            } |
            Format-Table -AutoSize -HideTableHeaders
        }
        # Windows 8, 2012
        ElseIf ($CurrentPC_OSVersion -like "6.2*") {
            Get-WmiObject -Class Win32_QuickFixEngineering -ComputerName $CurrentPC |
            Where-Object {
                $_.HotFixID -eq 'KB4012214' -or
                $_.HotFixID -eq 'KB4012217' -or
                $_.HotFixID -eq 'KB4015551' -or
                $_.HotFixID -eq 'KB4019216'
            } |
            Format-Table -AutoSize -HideTableHeaders
        }
        # Windows 2008
        ElseIf ($CurrentPC_OSVersion -like "6.0*") {
            Get-WmiObject -Class Win32_QuickFixEngineering -ComputerName $CurrentPC |
            Where-Object {
                $_.HotFixID -eq 'KB4012598'
            } |
            Format-Table -AutoSize -HideTableHeaders
        }
        # Если ничего из этого, то просто выход для перехода к следующему по списку
        # Exit from cycle, if nothing founded
        Else {
            $NotifyExitMessage = "Undefined OS/no WC-patches/patches not described"
            Write-Host $CurrentPC $CurrentPC_OSVersion $NotifyExitMessage
        }
}