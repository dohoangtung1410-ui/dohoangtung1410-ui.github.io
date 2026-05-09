# 👨‍💻 Đỗ Hoàng Tùng — Network & System Engineer Portfolio

> **"Không chỉ học lý thuyết — tôi xây dựng lab thực tế, viết automation code, và tấn công hệ thống của chính mình để hiểu cách phòng thủ thực sự hoạt động."**

📍 Việt Nam &nbsp;|&nbsp; 🎯 Vị trí mục tiêu: Network/System Engineer **Intern / Fresher**

---

## 🙋 About Me

Tôi là một kỹ thuật viên mạng & hệ thống tự học với niềm đam mê cháy bỏng trong việc **xây dựng và bảo vệ hạ tầng**. Thay vì dừng lại ở mức "biết cách dùng lệnh", tôi luôn đặt câu hỏi: *"Tại sao giao thức này hoạt động như vậy? Kẻ tấn công sẽ khai thác điểm nào? Và tôi có thể tự động hóa việc này không?"*

Từ việc cấu hình HSRP failover trên Cisco L3 Switch bằng Ansible Playbook, đến tự tay mô phỏng Evil-Twin attack bằng Kali Linux để kiểm chứng khả năng phòng thủ của hệ thống — mỗi dự án trong portfolio này đều xuất phát từ tư duy **"build it, break it, fix it"**.

Tôi tin rằng một kỹ sư giỏi không phải là người nhớ nhiều lệnh nhất — mà là người **hiểu tại sao** mỗi lệnh tồn tại và **biết khi nào** cần tự động hóa chúng.

---

## 🛠️ Kỹ năng kỹ thuật

### 🔵 Networking
| Kỹ năng | Mức độ |
|---|---|
| Cisco IOS (Routing & Switching) | ⬛⬛⬛⬛⬜ Intermediate |
| HSRP / VRRP — High Availability | ⬛⬛⬛⬛⬜ Intermediate |
| OSPF / EIGRP / Static Routing | ⬛⬛⬛⬜⬜ Working |
| VLAN / STP / Trunk | ⬛⬛⬛⬛⬜ Intermediate |
| 3-Layer Network Architecture | ⬛⬛⬛⬛⬜ Intermediate |
| EVE-NG Lab Simulation | ⬛⬛⬛⬛⬜ Intermediate |

### 🟢 Server Administration
| Kỹ năng | Mức độ |
|---|---|
| Ubuntu Server / CentOS | ⬛⬛⬛⬛⬜ Intermediate |
| Windows Server — AD DS, NPS | ⬛⬛⬛⬜⬜ Working |
| Nginx / MariaDB / PHP (LEMP) | ⬛⬛⬛⬛⬜ Intermediate |
| SSH Hardening / UFW / Fail2Ban | ⬛⬛⬛⬛⬜ Intermediate |

### 🟡 Automation / Tools
| Kỹ năng | Mức độ |
|---|---|
| Ansible Playbook (YAML) | ⬛⬛⬛⬜⬜ Working |
| Jinja2 Templates | ⬛⬛⬛⬜⬜ Working |
| Bash Scripting / Cronjob | ⬛⬛⬛⬛⬜ Intermediate |
| Git | ⬛⬛⬛⬜⬜ Working |

### 🔴 Security
| Kỹ năng | Mức độ |
|---|---|
| 802.1X / EAP-TLS / PEAP | ⬛⬛⬛⬜⬜ Working |
| RADIUS / Windows NPS | ⬛⬛⬛⬜⬜ Working |
| PKI / Digital Certificate (CA) | ⬛⬛⬛⬜⬜ Working |
| Evil-Twin Attack Simulation (Kali) | ⬛⬛⬛⬜⬜ Working |

---

## 🚀 Dự án nổi bật

---

### 📦 PROJECT 01 — Network Automation với Ansible & HSRP

**🏷️ Tags:** `Ansible` `HSRP` `Cisco IOS` `Jinja2` `EVE-NG` `High Availability`

#### 📋 Overview (STAR Model)

| | |
|---|---|
| **Situation** | Môi trường doanh nghiệp cần High Availability cho Default Gateway. Cấu hình thủ công gây sai sót, mất nhiều thời gian và thiếu nhất quán giữa các thiết bị trong mô hình mạng 3 lớp. |
| **Task** | Thiết kế và triển khai giải pháp HSRP tự động hóa hoàn toàn bằng Ansible trên Cisco L3 Switch, đảm bảo Idempotency và Failover tức thời. |
| **Action** | Thiết kế topology → Viết Playbook + Jinja2 template → Cấu hình Priority/Preempt → Test Failover |
| **Result** | Giảm 90% thời gian cấu hình, đảm bảo Idempotency, Failover < 3 giây |

#### 🔧 Tech Stack

| Component | Technology | Chi tiết |
|---|---|---|
| Automation Engine | Ansible 2.x | Playbook YAML, `ios_config` module |
| Config Templating | Jinja2 | Chuẩn hóa cấu hình interface/HSRP |
| Target Platform | Cisco IOS L3 | L3 Switch, HSRP, SVI configuration |
| Lab Environment | EVE-NG | Mô phỏng topology 3-lớp thực tế |

#### ⚙️ Key Implementation

```yaml
# hsrp_playbook.yml — Ansible Playbook: HSRP Auto-Configuration
---
- name: Configure HSRP on L3 Distribution Switches
  hosts: distribution_switches
  gather_facts: no
  vars_files:
    - vars/network_vars.yml

  tasks:
    - name: Configure SVI Interface
      cisco.ios.ios_config:
        lines:
          - "ip address {{ item.ip }} {{ item.mask }}"
          - "no shutdown"
        parents: "interface {{ item.vlan_int }}"
      loop: "{{ svi_interfaces }}"

    - name: Apply HSRP Configuration (Jinja2 Template)
      cisco.ios.ios_config:
        src: templates/hsrp.j2
      notify: Save Config

  handlers:
    - name: Save Config
      cisco.ios.ios_command:
        commands: write memory
```

```jinja2
{# templates/hsrp.j2 — Jinja2 Template for HSRP #}
{% for vlan in hsrp_groups %}
interface {{ vlan.interface }}
  standby {{ vlan.group }} ip {{ vlan.virtual_ip }}
  standby {{ vlan.group }} priority {{ vlan.priority }}
  standby {{ vlan.group }} preempt
  standby {{ vlan.group }} timers 1 3
{% endfor %}
```

#### ✅ Outcomes

- ⚡ Giảm **90% thời gian cấu hình thủ công** (~45 phút → ~4 phút)
- 🔄 Đảm bảo **Idempotency** — chạy nhiều lần không gây lỗi cấu hình
- ⏱️ Gateway Failover được kiểm chứng với thời gian hội tụ **< 3 giây**
- ♻️ Playbook tái sử dụng hoàn toàn chỉ bằng cách thay đổi file biến

---

### 🔐 PROJECT 02 — Wi-Fi Security: RADIUS 802.1X & Evil-Twin Lab

**🏷️ Tags:** `802.1X` `RADIUS` `EAP-TLS` `Windows Server NPS` `Active Directory` `Kali Linux` `Evil-Twin`

#### 📋 Overview (STAR Model)

| | |
|---|---|
| **Situation** | Wi-Fi doanh nghiệp dùng PSK dễ bị tấn công Evil-Twin và credential theft. Không có cơ chế xác thực tập trung hay audit log. |
| **Task** | Triển khai hạ tầng xác thực 802.1X tích hợp AD và kiểm chứng hiệu quả phòng thủ bằng cách tự thực hiện Evil-Twin attack trong môi trường lab kiểm soát. |
| **Action** | Cấu hình NPS RADIUS → Tích hợp AD DS → Deploy 802.1X + Certificate → Tấn công Evil-Twin → Phân tích kết quả |
| **Result** | Ngăn chặn 100% Rogue AP, quản lý tập trung log truy cập |

#### 🔧 Tech Stack

| Component | Technology | Chi tiết |
|---|---|---|
| RADIUS Server | Windows Server NPS | Network Policy Server |
| Identity Provider | Active Directory (AD DS) | Group Policy, Internal CA |
| Auth Protocol | 802.1X / EAP-TLS / PEAP | Mutual Certificate Authentication |
| Attack Simulation | Kali Linux | Hostapd-mana, Dnsmasq, Wireshark |

#### ⚙️ Key Implementation

**🏗️ RADIUS Architecture:**

```
[Wireless Client]
       │  ──── EAP Request ────►
       │
[Access Point / Authenticator]
       │  ──── RADIUS Access-Request ────►
       │
[Windows NPS — RADIUS Server]
       │  ──── LDAP Query ────►
       │
[Active Directory (AD DS)]
       │  ◄─── User/Cert Validation ─────
       │
[NPS issues RADIUS Access-Accept]
       │  ◄─── Certificate Challenge ────
       │
[Client validates Server Cert via CA]
       │  ──── EAP-TLS Mutual Auth ─────►
       │
      ✅ Authenticated & Connected
```

**⚔️ Evil-Twin Attack Flow:**

```bash
# Kali Linux — Rogue AP Setup (Lab Environment Only)
# Step 1: Create fake AP with identical SSID
hostapd-mana rogue_ap.conf

# Step 2: Serve fake DHCP to connected clients
dnsmasq -C dnsmasq.conf --dhcp-range=10.0.0.10,10.0.0.50

# Step 3: Capture EAP handshake
wireshark -i wlan0 -k -f "eap"

# RESULT: Client rejects connection ✗
# Reason: Server certificate NOT signed by trusted CA
# → Attack FAILED. PKI defense confirmed effective.
```

#### ✅ Outcomes

- 🛡️ Ngăn chặn thành công **100% Rogue AP** qua Certificate Validation
- 📊 Quản lý tập trung toàn bộ log xác thực qua NPS Event Log
- 🔬 Chứng minh thực tế EAP-TLS + PKI hiệu quả hơn PSK trong việc chống Evil-Twin
- 📜 Triển khai Digital Certificate từ Internal CA, giảm chi phí so với public CA

---

### 🖥️ PROJECT 03 — LEMP Stack Web Infrastructure & Hardening

**🏷️ Tags:** `Ubuntu Server` `Nginx` `MariaDB` `PHP` `UFW` `Fail2Ban` `Bash` `Cronjob`

#### 📋 Overview (STAR Model)

| | |
|---|---|
| **Situation** | Hệ thống web nội bộ cần triển khai trên Linux với bảo mật cao, tránh brute-force và có khả năng tự phục hồi dữ liệu. |
| **Task** | Build và harden toàn bộ LEMP Stack từ zero, áp dụng Principle of Least Privilege và Whitelist-only policy. |
| **Action** | Cài LEMP → SSH Hardening → UFW Whitelist → Fail2Ban → Auto-backup script với Cronjob |
| **Result** | Hệ thống chịu brute-force, auto-backup hàng ngày, recovery < 5 phút |

#### 🔧 Tech Stack

| Component | Technology | Hardening Applied |
|---|---|---|
| Web Server | Nginx | Disable `server_tokens`, custom error pages |
| Database | MariaDB | `mysql_secure_installation`, dedicated DB user |
| Runtime | PHP-FPM | `expose_php = Off`, disable dangerous functions |
| Firewall | UFW | Whitelist: 80/443/SSH-custom port only |
| IDS | Fail2Ban | SSH + Nginx jail, ban 1h sau 5 lần thất bại |
| Remote Access | SSH | Custom port, Key-only auth, disable root login |

#### ⚙️ Key Implementation

**SSH Hardening — `/etc/ssh/sshd_config`:**

```bash
# SSH Security Configuration
Port 2222                    # Non-standard port
PermitRootLogin no           # Disable root SSH
PasswordAuthentication no    # Key-only authentication
PubkeyAuthentication yes
MaxAuthTries 3               # Limit brute-force attempts
LoginGraceTime 30            # 30s timeout for auth
AllowUsers deploy_user       # Whitelist specific user
```

**UFW Whitelist Firewall:**

```bash
# Reset and apply Whitelist policy
ufw --force reset
ufw default deny incoming
ufw default allow outgoing

# Allow only necessary services
ufw allow 80/tcp comment 'HTTP'
ufw allow 443/tcp comment 'HTTPS'
ufw allow 2222/tcp comment 'SSH Custom Port'

ufw enable
```

**Auto-Backup Script:**

```bash
#!/bin/bash
# /opt/scripts/backup.sh
# Cronjob: 0 2 * * * /opt/scripts/backup.sh

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/var/backups/webapp"
WEBROOT="/var/www/html"
DB_NAME="production_db"
RETAIN_DAYS=7

mkdir -p "${BACKUP_DIR}/${TIMESTAMP}"

# Dump MariaDB with transaction consistency
mysqldump --single-transaction "${DB_NAME}" \
  | gzip > "${BACKUP_DIR}/${TIMESTAMP}/db.sql.gz"

# Archive source code
tar -czf "${BACKUP_DIR}/${TIMESTAMP}/webroot.tar.gz" \
  -C "${WEBROOT}" .

# Rotate old backups (keep last 7 days)
find "${BACKUP_DIR}" -maxdepth 1 -mtime +${RETAIN_DAYS} \
  -exec rm -rf {} \;

echo "[OK] Backup completed: ${TIMESTAMP}"
```

#### ✅ Outcomes

- 🛡️ **Block 100%** brute-force attempts sau 5 lần thử (Fail2Ban confirmed)
- 🔄 Auto-backup chạy **hàng ngày lúc 2AM**, lưu trữ 7 ngày rolling
- ⚡ Recovery time từ backup **< 5 phút**
- 🔒 SSH attack surface giảm đáng kể (custom port + key-only auth)
- 📦 Toàn bộ infrastructure có thể rebuild từ script trong < 30 phút

---

## 📬 Liên hệ & Call to Action

Tôi đang tìm kiếm cơ hội **Thực tập (Internship)** hoặc vị trí **Fresher** trong lĩnh vực Network/System Engineering để áp dụng và mở rộng các kỹ năng thực tế đã xây dựng. Sẵn sàng học hỏi nhanh và đóng góp giá trị ngay từ ngày đầu.

| Kênh | Thông tin |
|---|---|
| 🐱 **GitHub** | [github.com/dohoangtung1410-ui/CV](https://github.com/dohoangtung1410-ui/CV.git) |
| 📧 **Email** | dohoangtung1410@gmail.com |
| 📍 **Location** | Việt Nam |

---

> *Portfolio này được xây dựng và duy trì bởi Đỗ Hoàng Tùng. Tất cả các dự án đều được triển khai trong môi trường lab thực tế với mục đích học tập và nghiên cứu.*
