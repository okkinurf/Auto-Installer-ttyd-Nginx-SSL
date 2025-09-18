██████╗ █████╗ ████████╗ ██████╗ ██╗███╗ ██╗███████╗████████╗ █████╗ ██╗ ██╗
██╔══██╗██╔══██╗╚══██╔══╝██╔═══██╗ ██║████╗ ██║██╔════╝╚══██╔══╝██╔══██╗██║ ██║
██████╔╝███████║ ██║ ██║ ██║ ██║██╔██╗ ██║█████╗ ██║ ███████║██║ ██║
██╔═══╝ ██╔══██║ ██║ ██║ ██║ ██║██║╚██╗██║██╔══╝ ██║ ██╔══██║██║ ██║
██║ ██║ ██║ ██║ ╚██████╔╝ ██║██║ ╚████║███████╗ ██║ ██║ ██║███████╗███████╗
╚═╝ ╚═╝ ╚═╝ ╚═╝ ╚═════╝ ╚═╝╚═╝ ╚═══╝╚══════╝ ╚═╝ ╚═╝ ╚═╝╚══════╝╚══════╝

  🚀 Auto Installer ttyd + Nginx + SSL | by Okki Nurfadli


---

# 🚀 Auto Installer ttyd + Nginx + SSL

[![Build Status](https://img.shields.io/badge/build-passing-brightgreen?style=for-the-badge)]()  
[![OS](https://img.shields.io/badge/OS-Ubuntu%20%7C%20Debian-blue?style=for-the-badge&logo=linux)]()  
[![License](https://img.shields.io/github/license/okkinurf/Auto-Installer-ttyd-Nginx-SSL?style=for-the-badge)]()  
[![Stars](https://img.shields.io/github/stars/okkinurf/Auto-Installer-ttyd-Nginx-SSL?style=for-the-badge&logo=github)]()

Script otomatis untuk menginstall dan mengonfigurasi:

- [ttyd](https://github.com/tsl0922/ttyd) → terminal via browser  
- Nginx sebagai reverse proxy  
- SSL otomatis via Let’s Encrypt (Certbot)  
- Basic Authentication (username & password)  
- Auto-renew sertifikat SSL  

---

## 🎯 Fitur Utama

✅ Input interaktif (Domain, Port, IP Public, Username & Password)  
✅ `ttyd` dengan **mode writable** (keyboard aktif)  
✅ Nginx proxy dengan dukungan **WebSocket**  
✅ SSL otomatis + auto renew  
✅ Basic Auth dengan **multi user** support  

---

## ⚙️ Persyaratan

- OS: Ubuntu/Debian  
- Domain sudah resolve ke **IP server**  
- Port **80** & **port HTTPS proxy** terbuka  

---

## 🛠 Cara Install

```bash
git clone https://github.com/okkinurf/Auto-Installer-ttyd-Nginx-SSL.git
cd Auto-Installer-ttyd-Nginx-SSL
chmod +x Script.sh
sudo ./Script.sh


Lalu ikuti input interaktif:

Domain (contoh: console.domainku.my.id)

Port HTTPS proxy (contoh: 8080)

IP Public server

Username Basic Auth

Password Basic Auth

Akses hasil instalasi di:

https://<DOMAIN>:<PORT>

🔒 Manajemen User

File user disimpan di:

/etc/nginx/htpasswd/<domain>

Tambah User
sudo htpasswd /etc/nginx/htpasswd/<domain> <username>

Reset Password User
sudo htpasswd /etc/nginx/htpasswd/<domain> <username>

Hapus User
sudo htpasswd -D /etc/nginx/htpasswd/<domain> <username>


Reload nginx setelah perubahan:

sudo systemctl reload nginx

📜 Lisensi

MIT License © 2025 Okki Nurfadli
