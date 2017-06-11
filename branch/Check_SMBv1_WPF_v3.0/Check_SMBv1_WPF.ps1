# Locking working directory
Set-Location $PSScriptRoot
# Import WPF form
.\XamlBuilder.ps1 -XamlPath '.\Check_SMBv1_WPF_XamlForm.xaml'
# Import working functions from another file
. '.\Check_SMBv1_WPF_functions.ps1'

# Describe form's controls
# Описываем управляющие элементы формы
$btn_PCsListChoose.Add_Click({
    # Source file with PC's names
    $txt_PCsListFilePath.Text = Get-FileName "$env:USERPROFILE\Desktop"
})

$btn_DiscoveryResults.Add_Click({
    # File with discovery results
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
    $btn_StartDiscovery.Background = "Red"

    # Really job process
    Get-DiscoveryPCs $ComputersList

    # Notify: End process
    $lbl_CurrentStatus.Content = "End discovery"
    $btn_StartDiscovery.Background = "Green"
})

# Show form for people! :-)
# Теперь, когда всё готово, можно показать форму людям :-)
$xamGUI.ShowDialog() | Out-Null