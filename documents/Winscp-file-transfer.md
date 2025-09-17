# File Transfer Between Windows VMs Using WinSCP (via OpenSSH)

## 1. Introduction
This guide explains how to transfer files between two Windows Virtual Machines using **WinSCP**.  
Since WinSCP requires a file transfer protocol (SFTP, SCP, or FTP), we will enable **OpenSSH Server** on the target VM, which allows us to use **SFTP** for secure transfers.

---

## 2. Prerequisites
- Two running **Windows VMs** connected on the same network or accessible via public IP.  
- Administrative access to both VMs.  
- **WinSCP** installed on the source VM (download from [winscp.net](https://winscp.net)).  

---

## 3. Enable SSH Server on the Target VM

WinSCP requires a transfer protocol. We will enable **OpenSSH Server** on the target VM.

### Step 3.1: Install OpenSSH Server
Run the following PowerShell command as Administrator:
```powershell
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
```
✅ This installs the OpenSSH server feature on Windows.

---

### Step 3.2: Start and Configure the SSH Service
Run:
```powershell
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'
```
- `Start-Service sshd` → Starts the SSH server immediately.  
- `Set-Service -StartupType 'Automatic'` → Ensures SSH starts automatically after reboot.  

Check if the service is running:
```powershell
Get-Service sshd
```

---

### Step 3.3: Allow SSH Through Firewall
Add a firewall rule to allow inbound SSH (port 22):
```powershell
New-NetFirewallRule -Name sshd -DisplayName "OpenSSH Server" -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
```
✅ This ensures other VMs can connect via SSH/SFTP.

---

## 4. Get the Target VM’s IP Address
On the target VM, run:
```powershell
ipconfig
```
Look for the **IPv4 Address**. Example:
```
Ethernet adapter Ethernet 2:
   IPv4 Address. . . . . . . . . . . : 172.28.0.47
```
✅ This IP will be used as the **host name** in WinSCP.  

⚠️ If the VMs are in the cloud (Azure, AWS, GCP), ensure **port 22 is allowed** in the VM’s **security group / NSG**.

---

## 5. Test the SSH Connection
(Optional, but recommended before WinSCP)  
From the source VM, test the connection:
```powershell
ssh Administrator@172.28.0.47
```
- Replace `Administrator` with the actual Windows username.  
- Enter the password when prompted.  
- If you get a command prompt from the target VM → SSH is working.  

---

## 6. Connect with WinSCP

### Step 6.1: Open WinSCP and Create a New Site
1. Open **WinSCP** on the source VM.  
2. Click **New Site**.  
3. Enter connection details:
   - **File protocol**: `SFTP`  
   - **Host name**: `172.28.0.47` (target VM IP)  
   - **Port number**: `22`  
   - **User name**: `Administrator` (or another Windows user on the target VM)  
   - **Password**: the user’s Windows password  

---

### Step 6.2: Connect
- Click **Login**.  
- On first connection, accept the **host key** prompt.  
- If authentication succeeds, you will see the file explorer interface:
  - **Left pane** → Source VM (local).  
  - **Right pane** → Target VM (remote).  

---

## 7. Transfer Files
- To transfer files, **drag and drop** between the two panes.  
- Files will be securely copied via **SFTP**.  
- You can also use the right-click menu for **Upload**, **Download**, or **Synchronize** options.  

---

## 8. Troubleshooting
- **Connection refused** → Ensure `sshd` service is running:
  ```powershell
  Get-Service sshd
  ```
  If stopped:
  ```powershell
  Start-Service sshd
  ```

- **Authentication error** → Verify correct username/password. WinSCP does not accept blank passwords.  

- **Timeout / unreachable host** → Ensure firewall allows port 22, and check VM network connectivity.  

---

## 9. Conclusion
By enabling OpenSSH on the target VM and using WinSCP on the source VM, you can securely transfer files between two Windows VMs over SFTP. This method is secure, fast, and works for both local and cloud-hosted VMs.
