#ERASE ALL THIS AND PUT XAML BELOW between the @" "@ 
$inputXML = @"
<Window x:Class="powerGui1.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="postes Visiodent" Height="654.194" Width="576.657">
    <Grid>
        <Image HorizontalAlignment="Left" Height="139" VerticalAlignment="Top" Width="260" Source="C:\Users\FANTON-21126\Pictures\Logo CPAM-CSD Info small.jpg"/>
        <TextBlock HorizontalAlignment="Left" Height="139" Margin="260,0,0,0" TextWrapping="Wrap" Text="Cet outil va remplir un fichier excel tout seul. Et ouais !" VerticalAlignment="Top" Width="257" FontSize="18"/>
        <Button x:Name="btnOK" Content="OK" Height="32" Margin="502,582,10,0" VerticalAlignment="Top"/>
        <TextBox x:Name="textBox" HorizontalAlignment="Left" Height="40" Margin="260,144,0,0" TextWrapping="Wrap" Text="TextBox" VerticalAlignment="Top" Width="149"/>
        <Label Content="computerName" HorizontalAlignment="Left" Height="40" Margin="149,144,0,0" VerticalAlignment="Top" Width="106"/>
        <ListView x:Name="listView" HorizontalAlignment="Left" Height="388" Margin="10,189,0,0" VerticalAlignment="Top" Width="549">
            <ListView.View>
                <GridView>
                    <GridViewColumn Header="computerName" DisplayMemberBinding ="{Binding 'ComputerName'}" Width = "120"/>
                    <GridViewColumn Header="caption" DisplayMemberBinding ="{Binding 'Caption'}" Width = "120"/>
                    <GridViewColumn Header="PID" DisplayMemberBinding ="{Binding 'PID'}" Width = "120"/>
                    <GridViewColumn Header="SessionId" DisplayMemberBinding ="{Binding 'SessionId'}" Width = "120"/>
                </GridView>
            </ListView.View>
        </ListView>

    </Grid>
</Window>

"@       
 
$inputXML = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N",'N'  -replace '^<Win.*', '<Window'
 
 
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = $inputXML
#Read XAML
 
    $reader=(New-Object System.Xml.XmlNodeReader $xaml) 
  try{$Form=[Windows.Markup.XamlReader]::Load( $reader )}
catch{Write-Host "Unable to load Windows.Markup.XamlReader. Double-check syntax and ensure .net is installed."}
 
#===========================================================================
# Load XAML Objects In PowerShell
#===========================================================================
 
$xaml.SelectNodes("//*[@Name]") | %{Set-Variable -Name "WPF$($_.Name)" -Value $Form.FindName($_.Name)}
 
Function Get-FormVariables{
if ($global:ReadmeDisplay -ne $true){Write-host "If you need to reference this display again, run Get-FormVariables" -ForegroundColor Yellow;$global:ReadmeDisplay=$true}
write-host "Found the following interactable elements from our form" -ForegroundColor Cyan
get-variable WPF*
}
 
Get-FormVariables
 
#===========================================================================
# Actually make the objects work
#===========================================================================
 
 
#Sample entry of how to add data to a field
 
#$vmpicklistView.items.Add([pscustomobject]@{'VMName'=($_).Name;Status=$_.Status;Other="Yes"})


Function Get-Visio {
param($computername =$env:COMPUTERNAME)
 
Get-WMIObject Win32_process -ComputerName $computername -filter "Name = 'visiodent.exe'"| Select-Object @{Name='ComputerName';Ex={$computername}},`
                                                                    @{Name=‘PID‘;Expression={$_.ProcessID}},`
                                                                    @{Name=‘SessionId’;Expression={$_.SessionId}},`
                                                                    @{Name=‘Caption’;Expression={$_.Caption}}
}
$WPFtextBox.Text = $env:COMPUTERNAME

$WPFbtnOK.Add_Click({
    Get-Visio -computername $WPFtextBox.Text | % {$WPFlistView.items.add($_)}

    #$WPFlistView.Items.Add("111")
    
})
 
#===========================================================================
# Shows the form
#===========================================================================
write-host "To show the form, run the following" -ForegroundColor Cyan
$Form.ShowDialog() | out-null
