# 🔒 STIG Mapping – PowerShell Script Coverage
This document maps DISA Windows Server 2022 STIG findings to actions implemented in `Set-STIG-Baseline.ps1`.

---

## ✅ Password & Lockout Policies

| STIG ID | Description | Action in Script |
|--------|-------------|------------------|
| V-253376 | Enforce minimum password length of 14 | INF policy applied via `secedit` |
| V-253378 | Password complexity enabled | `PasswordComplexity = 1` |
| V-253380 | Maximum password age 60 days | `MaximumPasswordAge = 60` |
| V-253383 | Minimum password age 1 day | `MinimumPasswordAge = 1` |
| V-253384 | Password history size 24 | `PasswordHistorySize = 24` |
| V-253385 | Lock account after 5 bad attempts | `LockoutBadCount = 5` |

---

## ✅ Disable SMBv1

| STIG ID | Description | Action in Script |
|--------|-------------|------------------|
| V-253458 | SMBv1 must be disabled | Reg key: `HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters\SMB1 = 0` |

---

## ✅ Enable Audit Logging

| STIG ID | Description | Action in Script |
|--------|-------------|------------------|
| V-253453 | Enable audit for Logon/Logoff | `auditpol` command |
| V-253451 | Audit account logon events | `auditpol` command |
| V-253449 | Audit policy changes | `auditpol` command |

---

## ✅ Disable Unused Services

| Service | Description | STIG Alignment |
|---------|-------------|----------------|
| Fax | Unused printing/fax | Reduces attack surface |
| XboxNetApiSvc, XblGameSave | Gaming services | Not required on servers |
| DiagTrack | Telemetry service | May violate privacy/compliance |

---

## 📝 Notes
- Use `secedit` and `.inf` files for scalable STIG automation.
- Registry-based hardening works great for air-gapped environments.
- This file tracks compliance progress. Update as you add more rules.
