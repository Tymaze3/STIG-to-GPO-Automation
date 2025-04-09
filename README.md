# 🛡️ STIG-to-GPO-Automation

This repo is focused on automating the conversion of DISA STIG settings for Windows Server 2022 into formats usable in air-gapped or secure environments.

## 🔍 Goals
- [x] Create PowerShell scripts to apply common STIG settings
- [x] Generate `.inf` templates for importing into GPOs
- [ ] Build mapping of STIG IDs to GPO/Registry paths
- [ ] Document remediation of common STIG findings

## ⚙️ Tools Used
- PowerShell
- LGPO.exe
- GPMC / Security Compliance Toolkit
- DISA STIG Viewer

## 📂 File Structure
- `/PowerShell`: Scripts that automate STIG enforcement
- `/GPO_Exports`: Security templates (.inf) for GPO import
- `/Notes`: Mapping and checklist files for reference

## 📌 Related Skills
- GPO Management
- System Hardening
- Compliance Automation
- Scripting

---

> “Compliance is the baseline. Security is the goal.”  
