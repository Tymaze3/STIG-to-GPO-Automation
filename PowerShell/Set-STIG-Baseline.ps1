<#
.SYNOPSIS
Applies select STIG baseline settings for Windows Server 2022

.DESCRIPTION
This script applies hardening policies that align with DISA STIG requirements including password policies, account lockouts, audit logging, and SMB settings.

.NOTES
Test in lab environment first. Designed for standalone/offline use.
#>

Write-Host "==== Applying STIG Baseline Settings ====" -ForegroundColor Cyan

# -------------------------------
# Password Policy (via secedit)
# -------------------------------
$passwordPolicy = @"
[System Access]
MinimumPasswordLength = 14
PasswordComplexity = 1
MaximumPasswordAge = 60
MinimumPasswordAge = 1
PasswordHistorySize = 24
LockoutBadCount = 5
ResetLockoutCount = 15
LockoutDuration = 15
"@

$infPath = "$env:TEMP\STIG-PasswordPolicy.inf"
$passwordPolicy | Out-File -FilePath $infPath -Encoding ascii
secedit.exe /configure /db secedit.sdb /cfg $infPath /quiet

Write-Host "[+] Password and lockout policies applied" -ForegroundColor Green

# -------------------------------
# Disable SMBv1 (Registry)
# -------------------------------
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" `
    -Name SMB1 -PropertyType DWORD -Value 0 -Force | Out-Null

Write-Host "[+] SMBv1 disabled" -ForegroundColor Green

# -------------------------------
# Enable Audit Logging
# -------------------------------
auditpol /set /category:"Logon/Logoff" /success:enable /failure:enable
auditpol /set /category:"Account Logon" /success:enable /failure:enable
auditpol /set /category:"Policy Change" /success:enable /failure:enable

Write-Host "[+] Basic audit policies enabled" -ForegroundColor Green

# -------------------------------
# Disable Unused Services
# -------------------------------
$services = @("Fax", "XblGameSave", "XboxNetApiSvc", "DiagTrack")
foreach ($svc in $services) {
    Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
    Write-Host "[-] Service disabled: $svc"
}

Write-Host "==== STIG Baseline Configuration Complete ====" -ForegroundColor Cyan

