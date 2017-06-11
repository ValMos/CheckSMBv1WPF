[xml]$xamlSMBfull = @"
<Window
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="MainWindow" Height="250" Width="600">
    <Grid>
        <StackPanel Margin="5" Orientation="Vertical">
            <RadioButton x:Name="rbtn_SinglePC" GroupName="WCCheckMethod" Content="Single PC" IsChecked="True" Margin="5"/>
            <TextBox x:Name="txt_SinglePC" Margin="5" ToolTip="Type PC's name or IP-address"/>
            <RadioButton x:Name="rbtn_PCsList" GroupName="WCCheckMethod" Content="PCs List" Margin="5"/>
            <DockPanel>
                <Grid>
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="5*"/>
                        <ColumnDefinition Width="*"/>
                    </Grid.ColumnDefinitions>
                    <TextBox x:Name="txt_PCsListFilePath" VerticalAlignment="Center" Margin="5" Grid.Column="0" ToolTip="Choose file for discovery"/>
                    <Button x:Name="btn_PCsListChoose" Content="PCs list file" VerticalAlignment="Center" Margin="5" Grid.Column="1"/>
                </Grid>
            </DockPanel>

            <DockPanel>
                <DockPanel>
                    <Grid>
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="5*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <TextBox x:Name="txt_DiscoveryResults" VerticalAlignment="Center" Margin="5" Grid.Column="0" ToolTip="Choose file for results"/>
                        <Button x:Name="btn_DiscoveryResults" Content="Results File" VerticalAlignment="Center" Margin="5" Grid.Column="1"/>
                    </Grid>
                </DockPanel>
            </DockPanel>

            <DockPanel>
                <Button x:Name="btn_StartDiscovery" Content="Start Discovery" Margin="5"/>
            </DockPanel>

            <DockPanel>
                <Label x:Name="lbl_CurrentStatus" Content="Current Status will be show here" Margin="5"/>
            </DockPanel>

        </StackPanel>

    </Grid>
</Window>
"@

# Load requirements for form
[xml]$Global:xmlSMBWPF = $xamlSMBfull

try{
    Add-Type -AssemblyName PresentationCore,PresentationFramework,WindowsBase,system.windows.forms
} catch {
    Throw "Failed to load Windows Presentation Framework assemblies."
}

# Load form from XML
$Global:xamlSMBGUI = [Windows.Markup.XamlReader]::Load((new-object System.Xml.XmlNodeReader $xmlSMBWPF))

# Enumerate controls for form
$xmlSMBWPF.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach-Object{
    Set-Variable -Name ($_.Name) -Value $xamlSMBGUI.FindName($_.Name) -Scope Global
}

# This part was taken on
# Придумано не мной, взято здесь
# http://www.workingsysadmin.com/open-file-dialog-box-in-powershell/
# Thanx to Thomas Rayner, who posted this
# Всполмогательная функция для выбора файл
function Get-FileName ($initialDirectory) {
    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null

    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.InitialDirectory = $initialDirectory
    $OpenFileDialog.Filter = "Text file (*.txt)| *.txt"
    $OpenFileDialog.Title = "Choose file with PCs names for check updates"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.FileName
}

function PrintSearchResults () {
    Format-Table -AutoSize -HideTableHeaders | Out-File -Append $txt_DiscoveryResults.Text -Encoding utf8
}

####### Проверка на наличие обновлений для SMBv1 #######
####### Check patches for SMBv1 #######
# Список патчей был в сообщении в Telegram группе по SCCM, автора не запомнил, к сожалению
# Проверяем версию ОС для выбора правильного списка патчей
# Check OS version for choose correct patches list
function Get-DiscoveryPCs ($ComputersList) {

ForEach ($CurrentPC in $ComputersList) {
    $CurrentPC_OSVersion = (Get-WmiObject -Class Win32_OperatingSystem -ComputerName $CurrentPC).Version

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
            Format-Table -AutoSize -HideTableHeaders | Out-File -Append $txt_DiscoveryResults.Text -Encoding utf8
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
            Format-Table -AutoSize -HideTableHeaders | Out-File -Append $txt_DiscoveryResults.Text -Encoding utf8
        }
        # Windows XP
        ElseIf ($CurrentPC_OSVersion -like "5.1*") {
            Get-WmiObject -Class Win32_QuickFixEngineering -ComputerName $CurrentPC |
            Where-Object {
                $_.HotFixID -eq 'KB4012598'
            } |
            Format-Table -AutoSize -HideTableHeaders | Out-File -Append $txt_DiscoveryResults.Text -Encoding utf8
        }
        # Windows 2003
        ElseIf ($CurrentPC_OSVersion -like "5.2*") {
            Get-WmiObject -Class Win32_QuickFixEngineering -ComputerName $CurrentPC |
            Where-Object {
                $_.HotFixID -eq 'KB4012598'
            } |
            Format-Table -AutoSize -HideTableHeaders | Out-File -Append $txt_DiscoveryResults.Text -Encoding utf8
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
            Format-Table -AutoSize -HideTableHeaders | Out-File -Append $txt_DiscoveryResults.Text -Encoding utf8
        }
        # Windows 2008
        ElseIf ($CurrentPC_OSVersion -like "6.0*") {
            Get-WmiObject -Class Win32_QuickFixEngineering -ComputerName $CurrentPC |
            Where-Object {
                $_.HotFixID -eq 'KB4012598'
            } |
            Format-Table -AutoSize -HideTableHeaders | Out-File -Append $txt_DiscoveryResults.Text -Encoding utf8
        }
        # Если ничего из этого, то просто выход для перехода к следующему по списку
        # Exit from cycle, if nothing founded
        Else {
            $NotifyExitMessage = "Undefined OS/no WC-patches/patches not described"
            Write-Host $CurrentPC $CurrentPC_OSVersion $NotifyExitMessage
        }
}
Write-Host "Release all search cycles"
}

### $ComputersList = "localhost"

# Describe form's controls
# Описываем управляющие элементы формы
$btn_PCsListChoose.Add_Click({
    # $ComputersList = Get-Content $WPFform_InputData
    # $WPFform_InputData = Get-FileName "$env:USERPROFILE\Desktop"
    # $txt_PCsListFilePath.Text = $WPFform_InputData
    $txt_PCsListFilePath.Text = Get-FileName "$env:USERPROFILE\Desktop"
})

$btn_DiscoveryResults.Add_Click({
    $txt_DiscoveryResults.Text = Get-FileName "$env:USERPROFILE\Desktop"
})

$btn_StartDiscovery.Add_Click({
    # Check search scope
    if ($rbtn_SinglePC.IsChecked -eq $true) {
        $ComputersList = $txt_SinglePC.Text
    }
    elseif ($rbtn_PCsList.IsChecked -eq $true) {
        $ComputersList = Get-Content $txt_PCsListFilePath.Text
    }

    # Notify: Start process
    $lbl_CurrentStatus.Content = "Start discovery"
    #$btn_StartDiscovery.Background = "Red"
    # Debug: write variable
#    Write-Host "Tracking list" $txt_PCsListFilePath.Text
    # Get list of Computers
#    $ComputersList = Get-Content $txt_PCsListFilePath.Text
    # Debug: write variable
#    Write-Host "Final list" $ComputersList
    # Job: Start working progress
    Get-DiscoveryPCs $ComputersList
    # Notify: End process
    $lbl_CurrentStatus.Content = "End discovery"
    $btn_StartDiscovery.Background = "Green"
})

# Show form for people! :-)
# Теперь всё готово, поэтому можно показать форму
$xamlSMBGUI.ShowDialog() | Out-Null