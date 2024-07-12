#  Vuln PHP Server

This repository hosts the source code and config scripts for a vulnerable PHP web server designed as part of my Ethical Hacking assignment. 

## Scenario

This PHP web server is to be used for internal use within a company network. It is accessible via a private domain and serves sensitive data within the company premises.

## Server Configuration

The PHP web server runs on Apache, with Nginx as a reverse proxy to forward requests from the private domain (`server.cure51.com`) to the server IP (`192.168.1.2:8080`).

- **Operating System**: Ubuntu 24.04 LTS
- **Web Server**: Apache 2.4.58
- **Reverse PRoxy**: Nginx 1.24.0

## Exploits

The server does not validate file uploads or restrict file types, allowing for arbitrary file uploads. When a PHP file is uploaded to the server and accessed via its URL (e.g. `http://server.cure51.com/uploads/shell.php`), the PHP interpreter processes and executes the PHP code within the file. Uploading a reverse shell PHP script can allow an attacker to gain remote access to the server.