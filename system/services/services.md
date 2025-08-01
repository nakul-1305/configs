# Minimalist Windows Services Configuration

This document explains the impact of setting certain Windows services to Manual or Disabled.  
The goal is to reduce background activity while keeping essential functionality available.

---

## Services set to Manual

- vmms (Hyper-V Virtual Machine Management)  
  Allows WSL2/Hyper-V to function but does not start at boot. Service will start only when a VM or WSL2 instance is launched.

- ElevocService  
  AI microphone noise suppression will not run at boot. If an application requests it, the service can still start on demand.

- InstallService (Microsoft Store Install Service)  
  Microsoft Store apps (e.g. WhatsApp) can still install/update when needed, but the service does not run in the background at startup.

- Spooler (Print Spooler)  
  Printing is available, but the service only runs when a print job is initiated. Saves resources when no printer is used.

- RasMan (Remote Access Connection Manager)  
  Used for VPN and dial-up connections. Safe as Manual unless you use VPNs frequently.

- SysMain  
  On SSD systems, SysMain (Superfetch) often adds little benefit and can increase writes.  
  Setting it to Manual or Disabled is safe.

### Risky changes (may cause login issues — NOT RECOMMENDED)
- OneSyncSvc_xxxxx (Sync Host)  
  [reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\OneSyncSvc /v Start /t REG_DWORD /d 3 /f]  
  Setting to Manual prevents it from running at startup but allows Windows to start it if required.  
  Disabling completely (d 4) can cause login or profile sync issues on some systems.  
  Do not disable unless you are certain you don’t need Microsoft account sync.
  
---

## Services set to Disabled

- Windows Search  
  Indexing and Start menu search are disabled. File search will still work, but slower.

- DolbyDAXAPI  
  Disables Dolby audio enhancements. Sound works normally without Dolby effects.

- CDPSvc - Disabled [via services.msc GUI]
- CDPUserSvc_xxxxx  [reg add "HKLM\SYSTEM\CurrentControlSet\Services\CDPUserSvc" /v Start /t REG_DWORD /d 4 /f]
  Connected Devices Platform User Service. Handles cross-device sync and shared experiences. Disabling has no impact on local use. 
  CDPSvc is the core Connected Devices Platform service. If you disable CDPSvc in Services.msc, CDPUserSvc instances won’t function anyway. 
  You can note that both are related.

- ElanIapService  
  ELAN touchpad helper service. Disabling does not affect touchpad gestures on this system.

- LenovoFnAndFunctionKeys  
  Lenovo function key management. If hotkeys work without it, disabling is safe.

- Text Input Management Service [reg add "HKLM\SYSTEM\CurrentControlSet\Services\TextInputManagementService" /v Start /t REG_DWORD /d 4 /f] 
  Disabling this removes touch keyboard, emoji panel, and dictation features. 
  Safe if you only use hardware keyboard and do not need IMEs.

- whesvc (Windows Health and Optimized Experiences)  
  Disables telemetry, health reporting, and tips. No impact on core system use.

- WerSvc (Windows Error Reporting Service)  
  Disables Windows error reporting. Crashes will not be submitted to Microsoft.

---

## Summary

- Manual services will not consume resources at boot, but still work when triggered by applications or the system.  
- Disabled services are completely turned off. Features tied to them will no longer function.  
- This setup reduces background load while keeping essential services available on demand.
