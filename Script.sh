#!/bin/bash
set -e

clear
echo "============================================"
echo "   🚀 Auto Installer ttyd + Nginx + SSL"
echo "============================================"
echo

# 🔹 Minta input user
read -rp "👉 Masukkan domain yang akan digunakan (ex: console.cve.my.id): " DOMAIN
read -rp "👉 Masukkan port HTTPS proxy yang akan digunakan (ex: 8080): " PROXY_PORT
read -rp "👉 Masukkan IP Public server ini: " PUBLIC_IP
read -rp "👉 Masukkan username untuk Basic Auth: " AUTH_USER
read -rsp "👉 Masukkan password untuk Basic Auth: " AUTH_PASS
echo
EMAIL="admin@$DOMAIN"
TTD_PORT="7681"
NGINX_CONF="/etc/nginx/sites-available/$DOMAIN.conf"
WEBROOT="/var/www/letsencrypt"

echo "🔹 Domain      : $DOMAIN"
echo "🔹 Proxy Port  : $PROXY_PORT"
echo "🔹 IP Public   : $PUBLIC_IP"
echo "🔹 Basic Auth  : $AUTH_USER / (hidden)"
echo "🔹 Email       : $EMAIL"
echo

sleep 2

echo "🔹 [STEP 1] Install dependency..."
sudo apt update -y
sudo apt install -y build-essential cmake git libjson-c-dev libwebsockets-dev \
    nginx apache2-utils certbot curl

echo "🔹 [STEP 2] Install ttyd..."
if [ ! -f "/usr/local/bin/ttyd" ]; then
  wget -q https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 -O /usr/local/bin/ttyd
  chmod +x /usr/local/bin/ttyd
fi

echo "🔹 [STEP 3] Buat systemd service ttyd..."
sudo tee /etc/systemd/system/ttyd.service > /dev/null <<EOF
[Unit]
Description=ttyd - Share Terminal over Web
After=network.target

[Service]
ExecStart=/usr/local/bin/ttyd -p ${TTD_PORT} --writable /bin/bash -l
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable --now ttyd

echo "🔹 [STEP 4] Buat Basic Auth..."
sudo mkdir -p /etc/nginx/htpasswd
sudo htpasswd -bc /etc/nginx/htpasswd/${DOMAIN} "$AUTH_USER" "$AUTH_PASS"

echo "🔹 [STEP 5] Konfigurasi sementara Nginx (untuk verifikasi Certbot)..."
sudo mkdir -p $WEBROOT
sudo tee $NGINX_CONF > /dev/null <<EOF
server {
    listen 80;
    server_name $DOMAIN;

    location /.well-known/acme-challenge/ {
        root $WEBROOT;
    }

    location / {
        return 200 'Temporary Certbot Validation';
    }
}
EOF

sudo ln -sf $NGINX_CONF /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx

echo "🔹 [STEP 6] Generate SSL dengan Certbot..."
if sudo certbot certonly --webroot --preferred-challenges http \
   -w $WEBROOT -d $DOMAIN --agree-tos -m $EMAIL --non-interactive --rsa-key-size 4096; then
  echo "✅ SSL berhasil dibuat!"
else
  echo "❌ Gagal membuat SSL Certbot"
  echo "   Pastikan domain $DOMAIN resolve ke IP $PUBLIC_IP dan port 80 terbuka."
  exit 1
fi

echo "🔹 [STEP 7] Update konfigurasi Nginx untuk reverse proxy HTTPS..."
sudo tee $NGINX_CONF > /dev/null <<EOF
server {
    listen ${PROXY_PORT} ssl;
    server_name $DOMAIN;

    ssl_certificate /etc/letsencrypt/live/$DOMAIN/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;

    location / {
        proxy_pass http://127.0.0.1:${TTD_PORT};
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
        proxy_read_timeout 3600s;
        proxy_send_timeout 3600s;

        auth_basic "Restricted Access";
        auth_basic_user_file /etc/nginx/htpasswd/${DOMAIN};
    }
}
EOF

sudo nginx -t && sudo systemctl reload nginx

echo "🔹 [STEP 8] Tambahkan auto-renew SSL..."
if ! sudo crontab -l | grep -q "certbot renew"; then
  (sudo crontab -l 2>/dev/null; echo "0 3 * * * certbot renew --quiet && systemctl reload nginx") | sudo crontab -
fi

echo
echo "🎉 Instalasi selesai!"
echo "👉 Akses terminal di: https://$DOMAIN:${PROXY_PORT}"
echo "👉 Login dengan Basic Auth: $AUTH_USER / $AUTH_PASS"
