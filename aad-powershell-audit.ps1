function Connect-AAD{
    #Checks that AzureAD PowerShell V2 module is installed. If not prompt for install. Then connects/prompts for AAD credentials.
    $module = Get-Module AzureAD -ListAvailable
    if($module.count -eq 0){
        Write-Host "AzureAD PowerShell V2 module is not available"  -ForegroundColor yellow  
        $confirm = Read-Host "Are you sure you want to install module? [Y] Yes [N] No"
        if($confirm -match "[yY]"){
            Write-host "Installing Exchange Online PowerShell module"
            Install-Module AzureAD -Repository PSGallery -AllowClobber -Force
            Import-Module AzureAD
        }
        else{
            Write-Host "AzureAD module is required to connect to AzureAD. Please install module using Install-Module AzureAD cmdlet."
            exit
        }
    }
	
    # Connect to your Azure AD tenant 
    $null = Connect-AzureAD 
}

Write-Host "Please authenticate with AAD..." -NoNewline
Connect-AAD
Write-Host "thank you!`n"

Write-Host "Reading devices from AAD..." -NoNewline
$aadDevices = (Get-AzureADDevice -All $true).Where({ $_.DeviceTrustType -eq "ServerAd" -or $_.DeviceTrustType -eq "AzureAd" })
Write-Host "done.`n"

foreach ($aadDevice in $aadDevices){  
    if ($aadDevice.AlternativeSecurityIds.key -eq $null){
        $aadDevice.DisplayName
    }          
}

Read-Host "`nPress enter to close..."