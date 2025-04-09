# 🔒 STIG Mapping – Domain GPO Hardening for Windows Server 2022

This document maps specific DISA STIG findings for Windows Server 2022 to the corresponding automation steps in the `Apply-STIG-GPO.ps1` script, which enforces security settings via the **Default Domain Controllers Policy** using GPMC PowerShell cmdlets.

---

## 🎯 GPO Target Summary

- **GPO Name:** `Default Domain Controllers Policy`
- **Scope:** Domain Controllers OU
- **Tool Used:** PowerShell with `GroupPolicy` module
- **Script:** `Apply-STIG-GPO.ps1`

---

## ✅ STIGs Implemented via GPO

### 🔐 NTLM & SMB Protocol Hardening

| STIG ID      | Description                                       | Registry Key                                                                 | Value         | Method           |
|--------------|---------------------------------------------------|-------------------------------------------------------------------------------|---------------|------------------|
| V-253458     | SMBv1 must be disabled                            | `HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters\SMB1`        | `0`           | GPO Registry     |
| V-253465     | Require NTLMv2 & 128-bit encryption for servers   | `HKLM\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0\NtlmMinServerSec`          | `2684354560`  | GPO Registry     |

---

### 🧾 Audit Policy Configuration

| STIG ID      | Description                             | Audit Category        | Method     | Status         |
|--------------|-----------------------------------------|------------------------|------------|----------------|
| V-253449     | Audit Policy Change                     | `Policy Change`        | `auditpol` | Success/Fail ✅ |
| V-253451     | Audit Account Logon Events              | `Account Logon`        | `auditpol` | Success/Fail ✅ |
| V-253453     | Audit Logon/Logoff Events               | `Logon/Logoff`         | `auditpol` | Success/Fail ✅ |

📌 Audit settings are applied locally to the Domain Controller and enforced via `auditpol.exe`.

---

### 🧹 Unused Services Disabled (via GPO Registry Keys)

| Service Name     | Registry Path                                               | Value (`Start`) | Description                     |
|------------------|-------------------------------------------------------------|------------------|---------------------------------|
| `Fax`            | `HKLM\SYSTEM\CurrentControlSet\Services\Fax\Start`          | `4`              | Not needed on DC               |
| `XblGameSave`    | `...Services\XblGameSave\Start`                             | `4`              | Xbox gaming service            |
| `XboxNetApiSvc`  | `...Services\XboxNetApiSvc\Start`                           | `4`              | Xbox networking                 |
| `DiagTrack`      | `...Services\DiagTrack\Start`                               | `4`              | Windows telemetry               |

🛑 These services are disabled by modifying the `Start` value via the Default Domain Controllers Policy GPO.

---

## 🧠 Future Additions

| STIG ID      | Description                                 | Status        |
|--------------|---------------------------------------------|---------------|
| V-253376     | Min password length (14)                    | 🚧 Planned for GPO migration |
| V-253378     | Password complexity                         | ✅ (Local script only) |
| V-253385     | Lock after 5 failed logins                  | ✅ (Local script only) |

📝 Currently enforced in `Set-STIG-Baseline.ps1` via `secedit`; goal is to migrate to domain-level GPO.

---

## 📚 References

- [`Apply-STIG-GPO.ps1`](../PowerShell/Apply-STIG-GPO.ps1) – Domain GPO hardening script
- [`GPO_Changes.md`](GPO_Changes.md) – Technical registry/audit/service changes documented

---

> Created by Tymaze3 | STIG-to-GPO Automation Project 🛡️ | Windows Server 2022 (Air-Gapped)
