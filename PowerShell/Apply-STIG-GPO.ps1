<#
.SYNOPSIS
Applies select STIG settings to the Default Domain Controllers Policy via GPMC.

.DESCRIPTION
Automates registry-based and audit policy changes by writing them to the Default Domain Controllers Policy GPO. Must be run on a Domain Controller.

.NOTES
Author: Tymaze3
Tested on: Windows Server 2022 (Domain Controller)
#>

# -------------------------------
# PREP
# -------------------------------
Import-Module GroupPolicy

$GPOName = "Default Domain Controllers Policy"
Write-Host "Target GPO: $GPOName" -ForegroundColor Cyan

# -------------------------------
# 1. NTLM SSP Server Security (STIG: V-253458)
# -------------------------------
Set-GPRegistryValue -Name $GPOName `
    -Key "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0" `
    -ValueName "NtlmMinServerSec" `
    -Type DWORD `
    -Value 2684354560

Write-Host "[+] Applied NTLM SSP Server setting (Require NTLMv2 + 128-bit encryption)" -ForegroundColor Green

# -------------------------------
# 2. Disable SMBv1 (STIG: V-253458)
# -------------------------------
Set-GPRegistryValue -Name $GPOName `
    -Key "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" `
    -ValueName "SMB1" `
    -Type DWORD `
    -Value 0

Write-Host "[+] Disabled SMBv1 via registry setting" -ForegroundColor Green

# -------------------------------
# 3. Audit Policy Settings (Logon, Account Logon, Policy Change)
# -------------------------------
$auditSettings = @{
    "Logon/Logoff" = @("Success", "Failure")
    "Account Logon" = @("Success", "Failure")
    "Policy Change" = @("Success", "Failure")
}

foreach ($category in $auditSettings.Keys) {
    foreach ($type in $auditSettings[$category]) {
        AuditPol.exe /set /category:"$category" /$type:enable | Out-Null
    }
    Write-Host "[+] Enabled Audit: $category (Success & Failure)" -ForegroundColor Green
}

# -------------------------------
# 4. Disable Services (GPO startup script alternative)
# -------------------------------
$servicesToDisable = @("Fax", "XblGameSave", "XboxNetApiSvc", "DiagTrack")

foreach ($svc in $servicesToDisable) {
    Set-GPRegistryValue -Name $GPOName `
        -Key "HKLM\SYSTEM\CurrentControlSet\Services\$svc" `
        -ValueName "Start" `
        -Type DWORD `
        -Value 4  # 4 = Disabled

    Write-Host "[-] Service set to disabled in GPO: $svc"
}

Write-Host "✅ STIG GPO hardening applied to $GPOName" -ForegroundColor Cyan
