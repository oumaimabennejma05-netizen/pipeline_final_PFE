#!/usr/bin/env python3
"""
Script d'envoi des 4 emails de rapport GMAO via msmtp.
Toutes les variables sont lues depuis l'environnement.
A placer dans : scripts/send_emails.py
"""
import subprocess
import os
import sys


def send_email(to_addr, subject, html_body):
    gmail_user = os.environ.get("GMAIL_USER", "")
    msg = (
        "To: " + to_addr + "\r\n"
        "From: " + gmail_user + "\r\n"
        "Subject: " + subject + "\r\n"
        "MIME-Version: 1.0\r\n"
        "Content-Type: text/html; charset=UTF-8\r\n"
        "\r\n"
        + html_body
    )
    result = subprocess.run(
        ["msmtp", to_addr],
        input=msg,
        text=True,
        capture_output=True
    )
    if result.returncode == 0:
        print("OK - Email envoye : " + subject)
    else:
        print("ERREUR envoi '" + subject + "' : " + result.stderr)
        sys.exit(1)


TO          = "oumaimabn.amelmm@gmail.com"
DATE        = os.environ.get("DATE", "")
RUN_URL     = os.environ.get("RUN_URL", "")
BRANCH      = os.environ.get("BRANCH", "")
COMMIT      = os.environ.get("COMMIT", "")[:8]
ACTOR       = os.environ.get("ACTOR", "")
VM_IP       = os.environ.get("VM_IP", "")
INSTANCE_ID = os.environ.get("INSTANCE_ID", "")
J0          = os.environ.get("J0_STATUS", "")
J1          = os.environ.get("J1_STATUS", "")
J2          = os.environ.get("J2_STATUS", "")
J3          = os.environ.get("J3_STATUS", "")
J4_SAST     = os.environ.get("J4_SAST", "")
J4_SUMMARY  = os.environ.get("J4_SUMMARY", "")
J4_BLOCKING = os.environ.get("J4_BLOCKING", "false")
J5_DAST     = os.environ.get("J5_DAST", "")
J5_SUMMARY  = os.environ.get("J5_SUMMARY", "")
CPU         = os.environ.get("CPU", "N/A")
MEM         = os.environ.get("MEM", "N/A")
DISK        = os.environ.get("DISK", "N/A")
MEM_TOTAL   = os.environ.get("MEM_TOTAL", "N/A")
MEM_USED    = os.environ.get("MEM_USED", "N/A")
DISK_TOTAL  = os.environ.get("DISK_TOTAL", "N/A")
DISK_USED   = os.environ.get("DISK_USED", "N/A")
DISK_FREE   = os.environ.get("DISK_FREE", "N/A")
UPTIME      = os.environ.get("UPTIME", "N/A")
LOAD        = os.environ.get("LOAD", "N/A")
BACKEND_S   = os.environ.get("BACKEND_S", "stopped")
FRONTEND_S  = os.environ.get("FRONTEND_S", "stopped")
ALARM_CPU   = os.environ.get("ALARM_CPU", "UNKNOWN")
ALARM_MEM   = os.environ.get("ALARM_MEM", "UNKNOWN")
ALARM_DISK  = os.environ.get("ALARM_DISK", "UNKNOWN")

STYLE = (
    "<style>"
    "body{font-family:Arial,sans-serif;background:#f5f5f5;margin:0;padding:20px}"
    ".box{max-width:700px;margin:auto;background:white;border-radius:8px;"
    "overflow:hidden;box-shadow:0 2px 8px rgba(0,0,0,.1)}"
    ".hdr{padding:24px;text-align:center;color:white}"
    ".hdr h1{margin:0;font-size:22px}"
    ".hdr p{margin:8px 0 0;opacity:.9;font-size:14px}"
    ".bdy{padding:24px}"
    ".card{background:#f9f9f9;border-radius:6px;padding:16px;margin-bottom:16px}"
    ".card h2{margin:0 0 12px;font-size:15px;color:#333}"
    ".row{display:flex;justify-content:space-between;align-items:center;"
    "margin-bottom:8px;font-size:13px;gap:12px}"
    ".lbl{color:#666;flex-shrink:0}"
    ".val{font-weight:bold;color:#222;text-align:right}"
    "table{width:100%;border-collapse:collapse;font-size:12px;margin-top:8px}"
    "th{background:#232f3e;color:white;padding:8px;text-align:left}"
    "td{padding:7px 8px;border-bottom:1px solid #eee;vertical-align:middle}"
    ".btn{display:inline-block;background:#232f3e;color:white;padding:10px 20px;"
    "border-radius:6px;text-decoration:none;font-size:13px;margin-top:12px;margin-right:8px}"
    ".aws{background:#ff9900}"
    ".bdg{display:inline-block;padding:2px 10px;border-radius:10px;"
    "font-size:11px;font-weight:bold;color:white}"
    ".ubox{background:#232f3e;color:#7ec8e3;padding:10px 14px;border-radius:6px;"
    "font-family:monospace;font-size:12px;margin-bottom:8px}"
    ".ftr{background:#f0f0f0;padding:14px;text-align:center;font-size:11px;color:#888}"
    "</style>"
)


def bdg(color, text):
    return "<span class='bdg' style='background:" + color + "'>" + text + "</span>"


def job_badge(s):
    if "success" in s:
        return bdg("#2ea44f", "OK")
    if "skipped" in s:
        return bdg("#888", "IGNORE")
    return bdg("#ff4444", "ECHEC")


def alarm_badge(state):
    if state == "OK":
        return bdg("#2ea44f", "OK")
    if state == "ALARM":
        return bdg("#ff4444", "ALARME")
    return bdg("#888", "INCONNU")


def svc_badge(s):
    if s == "running":
        return bdg("#2ea44f", "EN MARCHE")
    return bdg("#ff4444", "ARRETE")


def gauge(val, label):
    try:
        v = float(val)
        c = "#2ea44f" if v < 70 else "#ff9900" if v < 85 else "#ff4444"
        p = min(v, 100)
        return (
            "<div style='margin-bottom:14px'>"
            "<div style='display:flex;justify-content:space-between;"
            "font-size:13px;margin-bottom:4px'>"
            "<span style='color:#555'>" + label + "</span>"
            "<span style='font-weight:bold;color:" + c + "'>" + str(round(v, 1)) + "%</span>"
            "</div>"
            "<div style='background:#e0e0e0;border-radius:6px;height:10px;overflow:hidden'>"
            "<div style='background:" + c + ";width:" + str(p) + "%;"
            "height:100%;border-radius:6px'></div>"
            "</div></div>"
        )
    except Exception:
        return (
            "<div style='margin-bottom:10px;font-size:13px'>"
            "<span style='color:#555'>" + label + "</span> "
            "<span style='color:#888'>N/A</span></div>"
        )


def wrap(color, title, body_html):
    return (
        "<!DOCTYPE html><html><head><meta charset='UTF-8'>" + STYLE + "</head><body>"
        "<div class='box'>"
        "<div class='hdr' style='background:" + color + "'>"
        "<h1>" + title + "</h1><p>" + DATE + "</p></div>"
        "<div class='bdy'>" + body_html + "</div>"
        "<div class='ftr'>GMAO Pipeline CI/CD - rapport automatique</div>"
        "</div></body></html>"
    )


def card(border_color, title, content):
    return (
        "<div class='card' style='border-left:4px solid " + border_color + "'>"
        "<h2>" + title + "</h2>" + content + "</div>"
    )


def row(label, value):
    return (
        "<div class='row'>"
        "<span class='lbl'>" + label + "</span>"
        "<span class='val'>" + value + "</span>"
        "</div>"
    )


def btn(url, text, extra_class=""):
    return "<a href='" + url + "' class='btn " + extra_class + "'>" + text + "</a>"


# ════════════════════════════════════════════════════════════════════════════
# EMAIL 1 — Rapport SAST
# ════════════════════════════════════════════════════════════════════════════
if J4_BLOCKING == "true":
    sc, si = "#ff4444", "BLOQUANT - CVE critique"
elif J4_SAST == "issues_found":
    sc, si = "#ff9900", "AVERTISSEMENT"
else:
    sc, si = "#2ea44f", "PROPRE - aucune faille"

body1 = (
    card(sc, "Statut global",
         row("Resultat", si) + row("Resume", J4_SUMMARY))
    + card(sc, "Deploiement",
           row("Branche", BRANCH) + row("Commit", COMMIT) +
           row("Declenche par", ACTOR) + row("Date", DATE))
    + card(sc, "Outils utilises",
           "<table><tr><th>Outil</th><th>Role</th><th>Cible</th></tr>"
           "<tr><td><b>Semgrep</b></td><td>Analyse code source</td><td>Fichiers .java et .ts</td></tr>"
           "<tr><td><b>Trivy</b></td><td>CVE dependances</td><td>pom.xml et package.json</td></tr>"
           "<tr><td><b>SpotBugs</b></td><td>Bugs bytecode</td><td>Classes Java compilees</td></tr>"
           "</table>")
    + btn(RUN_URL, "Voir dans GitHub Actions")
)
send_email(TO, "[GMAO] SAST - " + si + " - " + DATE,
           wrap(sc, "Rapport SAST - Application GMAO", body1))

# ════════════════════════════════════════════════════════════════════════════
# EMAIL 2 — Rapport DAST
# ════════════════════════════════════════════════════════════════════════════
if J5_DAST == "high_found":
    dc, di = "#ff4444", "ALERTE HIGH"
elif J5_DAST == "medium_found":
    dc, di = "#ff9900", "ATTENTION MEDIUM"
else:
    dc, di = "#2ea44f", "OK - aucune alerte"

body2 = (
    card(dc, "Statut global",
         row("Resultat DAST", di) + row("Resume alertes", J5_SUMMARY) +
         row("Branche", BRANCH) + row("Commit", COMMIT))
    + card(dc, "Cibles scannees",
           "<table><tr><th>Cible</th><th>URL</th><th>Scan</th></tr>"
           "<tr><td>Backend Spring Boot</td><td>http://" + VM_IP + ":8080</td><td>ZAP Full Scan</td></tr>"
           "<tr><td>Frontend Angular</td><td>http://" + VM_IP + ":4200</td><td>ZAP Full Scan</td></tr>"
           "<tr><td>API REST</td><td>http://" + VM_IP + ":8080/v3/api-docs</td><td>ZAP API Scan</td></tr>"
           "</table>")
    + card(dc, "Attaques testees par ZAP",
           "<table><tr><th>Attaque</th><th>Description</th></tr>"
           "<tr><td>Injection SQL</td><td>Acces BD via formulaires</td></tr>"
           "<tr><td>XSS</td><td>Injection scripts malveillants</td></tr>"
           "<tr><td>CSRF</td><td>Tokens anti-falsification</td></tr>"
           "<tr><td>Headers HTTP</td><td>En-tetes de securite</td></tr>"
           "<tr><td>CORS</td><td>Politique cross-origine</td></tr>"
           "<tr><td>Path Traversal</td><td>Acces fichiers systeme</td></tr>"
           "</table>")
    + btn(RUN_URL, "Voir dans GitHub Actions")
)
send_email(TO, "[GMAO] DAST - " + di + " - " + DATE,
           wrap(dc, "Rapport DAST - Application GMAO", body2))

# ════════════════════════════════════════════════════════════════════════════
# EMAIL 3 — Rapport Monitoring
# ════════════════════════════════════════════════════════════════════════════
CW_URL = "https://console.aws.amazon.com/cloudwatch/home?region=us-east-1"

body3 = (
    card("#232f3e", "Utilisation des ressources (temps reel)",
         gauge(CPU, "CPU") + gauge(MEM, "Memoire RAM") + gauge(DISK, "Disque"))
    + card("#232f3e", "Detail memoire et disque",
           "<table><tr><th>Ressource</th><th>Total</th><th>Utilise</th><th>Libre</th></tr>"
           "<tr><td>RAM</td><td>" + MEM_TOTAL + "</td><td>" + MEM_USED + "</td><td>-</td></tr>"
           "<tr><td>Disque (/)</td><td>" + DISK_TOTAL + "</td><td>" + DISK_USED + "</td>"
           "<td>" + DISK_FREE + "</td></tr></table>")
    + card("#232f3e", "Etat des services applicatifs",
           "<div class='row'><span class='lbl'>Backend Spring Boot (:8080)</span>" + svc_badge(BACKEND_S) + "</div>"
           "<div class='row'><span class='lbl'>Frontend Angular (:4200)</span>" + svc_badge(FRONTEND_S) + "</div>"
           + row("Uptime serveur", UPTIME)
           + row("Charge systeme (load avg)", LOAD))
    + card("#232f3e", "Etat des alarmes CloudWatch",
           "<table><tr><th>Alarme</th><th>Seuil</th><th>Etat</th></tr>"
           "<tr><td>CPU eleve</td><td>&gt; 80%</td><td>" + alarm_badge(ALARM_CPU) + "</td></tr>"
           "<tr><td>Memoire elevee</td><td>&gt; 85%</td><td>" + alarm_badge(ALARM_MEM) + "</td></tr>"
           "<tr><td>Disque plein</td><td>&gt; 90%</td><td>" + alarm_badge(ALARM_DISK) + "</td></tr>"
           "</table>")
    + card("#232f3e", "Informations instance AWS",
           row("Instance ID", INSTANCE_ID) + row("IP publique", VM_IP) +
           row("Region AWS", "us-east-1") + row("Logs backend", "/gmao/backend") +
           row("Logs frontend", "/gmao/frontend"))
    + btn(RUN_URL, "GitHub Actions")
    + btn(CW_URL, "Ouvrir CloudWatch", "aws")
)
send_email(TO, "[GMAO] Monitoring CloudWatch - " + DATE,
           wrap("#232f3e", "Rapport Monitoring - CloudWatch", body3))

# ════════════════════════════════════════════════════════════════════════════
# EMAIL 4 — Resume final deploiement
# ════════════════════════════════════════════════════════════════════════════
if J1 == "success" and J3 == "success":
    fc, fs = "#2ea44f", "DEPLOIEMENT REUSSI"
else:
    fc, fs = "#ff4444", "DEPLOIEMENT ECHOUE"

body4 = (
    card(fc, "Informations du deploiement",
         row("Branche", BRANCH) + row("Commit", COMMIT) +
         row("Declenche par", ACTOR) + row("Date", DATE))
    + card(fc, "Statut de chaque job",
           "<div class='row'><span class='lbl'>JOB 0 - Validation code</span>" + job_badge(J0) + "</div>"
           "<div class='row'><span class='lbl'>JOB 1 - Creation VM EC2</span>" + job_badge(J1) + "</div>"
           "<div class='row'><span class='lbl'>JOB 2 - Post-installation</span>" + job_badge(J2) + "</div>"
           "<div class='row'><span class='lbl'>JOB 3 - Demarrage application</span>" + job_badge(J3) + "</div>"
           "<div class='row'><span class='lbl'>JOB 4 - SAST</span>"
           "<span class='val' style='font-size:11px'>" + J4_SAST + " - " + J4_SUMMARY + "</span></div>"
           "<div class='row'><span class='lbl'>JOB 5 - DAST</span>"
           "<span class='val' style='font-size:11px'>" + J5_DAST + " - " + J5_SUMMARY + "</span></div>"
           "<div class='row'><span class='lbl'>JOB 6 - Monitoring</span>"
           "<span class='val' style='font-size:11px'>CPU: " + CPU + "% | MEM: " + MEM + "% | DISK: " + DISK + "%</span></div>")
    + card(fc, "Acces a l application",
           "<div class='ubox'>Backend  : http://" + VM_IP + ":8080</div>"
           "<div class='ubox'>Frontend : http://" + VM_IP + ":4200</div>")
    + btn(RUN_URL, "Voir dans GitHub Actions")
)
send_email(TO, "[GMAO] " + fs + " - " + DATE, wrap(fc, fs, body4))

print("Tous les emails ont ete envoyes avec succes.")