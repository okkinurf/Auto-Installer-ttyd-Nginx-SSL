---

````markdown
# 🚀 Auto Installer ttyd + Nginx + SSL

Script otomatis untuk menginstall dan mengonfigurasi:

- [ttyd](https://github.com/tsl0922/ttyd) → terminal via browser  
- Nginx sebagai reverse proxy  
- SSL otomatis via Let’s Encrypt (Certbot)  
- Basic Authentication (username & password)  
- Auto-renew sertifikat SSL  

---

## 🎯 Fitur Utama

- Input interaktif saat instalasi:  
  - Domain  
  - Port HTTPS proxy  
  - IP publik server  
  - Username & password Basic Auth
- `ttyd` dijalankan dengan opsi `--writable` (keyboard aktif di browser)  
- SSL otomatis dengan auto-renew (via cron)  
- Nginx sudah disiapkan untuk **proxy WebSocket** (biar ttyd berjalan lancar)  
- Proteksi login dengan Basic Auth  

---

## ⚙️ Persyaratan

- OS: Ubuntu/Debian (support apt & systemd)  
- Domain sudah resolve ke **IP server**  
- Port 80 dan port HTTPS proxy (contoh: 8080) terbuka di firewall  

---

## 🛠 Cara Install

1. Clone repo ini:

   ```bash
   git clone https://github.com/okkinurf/Auto-Installer-ttyd-Nginx-SSL.git
   cd Auto-Installer-ttyd-Nginx-SSL
````

2. Jadikan script bisa dieksekusi:

   ```bash
   chmod +x Script.sh
   ```

3. Jalankan script:

   ```bash
   sudo ./Script.sh
   ```

4. Ikuti input interaktif:

   * Domain (contoh: `console.domainku.my.id`)
   * Port HTTPS proxy (contoh: `8080`)
   * IP Public server
   * Username Basic Auth
   * Password Basic Auth

5. Setelah selesai, akses:

   ```
   https://<DOMAIN>:<PROXY_PORT>
   ```

   lalu login menggunakan **username** dan **password** yang sudah kamu buat.

---

## 🔒 Manajemen User

File user disimpan di:

```
/etc/nginx/htpasswd/<domain>
```

* **Tambah user baru:**

  ```bash
  sudo htpasswd /etc/nginx/htpasswd/<domain> <username_baru>
  ```

* **Reset password user lama:**

  ```bash
  sudo htpasswd /etc/nginx/htpasswd/<domain> <username>
  ```

* **Hapus user:**

  ```bash
  sudo htpasswd -D /etc/nginx/htpasswd/<domain> <username>
  ```

* Reload nginx:

  ```bash
  sudo systemctl reload nginx
  ```

---

## 💡 Troubleshooting

| Masalah                   | Solusi                                                 |
| ------------------------- | ------------------------------------------------------ |
| Certbot gagal issue SSL   | Pastikan domain resolve ke IP server & port 80 terbuka |
| Keyboard tidak bisa input | Pastikan `ttyd` dijalankan dengan opsi `--writable`    |
| Port sudah dipakai        | Gunakan `ss -ltnp` untuk cek, hentikan service lama    |

---

## 📄 Contoh Isi Script.sh

```bash
#!/bin/bash
set -e

clear
read -rp "👉 Masukkan domain yang akan digunakan (ex: domain.my.id): " DOMAIN 
read -rp "👉 Masukkan port HTTPS proxy yang akan digunakan (ex: 8080): " PROXY_PORT
read -rp "👉 Masukkan IP Public server ini: " PUBLIC_IP
read -rp "👉 Masukkan username untuk Basic Auth: " AUTH_USER
read -rsp "👉 Masukkan password untuk Basic Auth: " AUTH_PASS
echo

# ... isi script auto installer
```

---

## 📜 Lisensi

MIT License © 2025 [Okki Nurfadli](https://github.com/okkinurf)


Mau saya bikinkan juga **banner markdown** (ASCII style atau pakai shields.io badge) biar README-nya makin keren?
```
