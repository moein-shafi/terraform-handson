#!/bin/bash
set -eux
apt-get update -y
apt-get install -y nginx
cat > /var/www/html/index.html <<'HTML'
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Hello from Terraform</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <style>
    body { font-family: sans-serif; margin: 2rem; }
    code { background: #f5f5f5; padding: .2rem .4rem; border-radius: .2rem; }
  </style>
</head>
<body>
  <h1>It works 🎉</h1>
  <p>This Nginx server was provisioned by <strong>Terraform</strong>.</p>
  <p>Path: <code>/var/www/html/index.html</code></p>
</body>
</html>
HTML
systemctl enable nginx
systemctl restart nginx
