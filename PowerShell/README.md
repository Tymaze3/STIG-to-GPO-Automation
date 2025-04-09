# 🧠 PowerShell Scripts for STIG Automation

This folder contains PowerShell scripts designed to apply DISA STIG-aligned security settings to Windows Server 2022 environments.

---

## 📌 Scripts Included

### `Set-STIG-Baseline.ps1`
- Applies STIG hardening directly to the **local machine**
- Uses:
  - `secedit` for password policies
  - `registry` edits for SMBv1 and NTLM
  - `auditpol` for audit settings
- Intended for air-gapped, standalone machines (e.g., isolated DCs or servers)

### `Apply-STIG-GPO.ps1`
- Targets the **Default Domain Controllers Policy** in Active Directory
- Modifies domain-level GPO settings using `Set-GPRegistryValue`
- Applies:
  - NTLM security requirements
  - Disables SMBv1
  - Hardens audit policy categories
  - Disables unused services via registry-based GPO entries

---

## ⚙️ Requirements

- Run scripts as **Administrator**
- `Apply-STIG-GPO.ps1` must be run on a **Domain Controller**
- GPMC tools must be installed (`GroupPolicy` module)
- PowerShell 5.1 or higher

---

## 📚 Related Documentation

- [`GPO_Changes.md`](../Notes/GPO_Changes.md): Details of what’s modified by `Apply-STIG-GPO.ps1`
- [`STIG_Mapping.md`](../Notes/STIG_Mapping.md): Maps specific STIG findings to script actions

---

## 🛡️ Future Additions

- More scripts for:
  - Advanced GPO linking
  - STIG export/reporting
  - `.inf` and `.reg` templates for offline use

---

> Security isn't just configuration — it's enforcement and verification. – Tymaze3
