# 📝 GPO_Changes.md
This file lists all the registry and policy settings applied by `Apply-STIG-GPO.ps1`, which targets the **Default Domain Controllers Policy** using the GPMC PowerShell module.

---

## 🎯 Target GPO
**Name:** `Default Domain Controllers Policy`  
**Scope:** Domain Controllers OU  
**Tool Used:** `Set-GPRegistryValue` and `auditpol`

---

## 🔐 Security Registry Modifications

| Setting | Registry Path | Value | Description |
|--------|----------------|--------|-------------|
| **NTLM SSP (Require NTLMv2 + 128-bit)** | `HKLM\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0\NtlmMinServerSec` | `2684354560` | Bitwise combo to enforce NTLMv2 and 128-bit encryption |
| **Disable SMBv1** | `HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters\SMB1` | `0` | Disables insecure SMBv1 protocol |

---

## 🧾 Audit Policy Modifications

| Category        | Type      | Status |
|----------------|-----------|--------|
| Logon/Logoff   | Success   | Enabled |
| Logon/Logoff   | Failure   | Enabled |
| Account Logon  | Success   | Enabled |
| Account Logon  | Failure   | Enabled |
| Policy Change  | Success   | Enabled |
| Policy Change  | Failure   | Enabled |

📌 Modified via `auditpol.exe` command (applies to local audit policy of DC).

---

## 🧹 Disabled Services (via GPO Registry)

| Service Name     | Registry Path | Value (`Start`) | Meaning |
|------------------|----------------|------------------|---------|
| `Fax`            | `HKLM\SYSTEM\CurrentControlSet\Services\Fax` | `4` | Disabled |
| `XblGameSave`    | `...Services\XblGameSave` | `4` | Disabled |
| `XboxNetApiSvc`  | `...Services\XboxNetApiSvc` | `4` | Disabled |
| `DiagTrack`      | `...Services\DiagTrack` | `4` | Disabled (Telemetry) |

🛑 Note: These do **not stop the services**, they set them to **"Disabled"** state via GPO registry keys.

---

## 📌 Verification Locations

- **GPMC → Default Domain Controllers Policy → Settings → Registry**
- **Audit settings:** Run `auditpol /get /category:*` on the DC
- **Registry values:** Use `regedit` or `Get-ItemProperty` in PowerShell

---

## 📚 Related Files

- [`Apply-STIG-GPO.ps1`](../PowerShell/Apply-STIG-GPO.ps1) – Script that applies these changes
- [`STIG_Mapping.md`](STIG_Mapping.md) – Maps settings to DISA STIG IDs

---

> Generated for `Tymaze3` - Air-Gapped STIG Compliance Project 🛡️
