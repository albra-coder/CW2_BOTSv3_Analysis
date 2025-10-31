# COMP3010 CW1 - PCAP Analysis Findings

## Victim Information
- **Victim IP Address**: 10.9.23.102
- **Hostname**: DESKTOP-IOJC6RB
- **Domain**: goingfortune.com
- **DNS Server**: 10.9.23.5
- **Capture Duration**: 1270.3 seconds (~21 minutes)
- **Total Packets**: 70,873

---

## Part 1: Initial Infection & File Transfer

### Question 1: When did the initial malicious HTTP connection occur?
**Answer**: `2021-09-24 21:44:38`
- Frame: 1735
- Full timestamp: 2021-09-24T21:44:38.990412000+0500

### Question 2: Name of compressed file downloaded?
**Answer**: `documents.zip`
- Size: 193 KB (197,792 bytes)
- Downloaded from attirenepal.com

### Question 3: Which domain hosted the malicious file?
**Answer**: `attirenepal.com`
- IP Address: 85.187.128.24
- Request: GET /incidunt-consequatur/documents.zip

### Question 4: Name of file inside the compressed archive?
**Answer**: `chart-1530076591.xls`
- File type: Microsoft Excel file
- Size: 251,392 bytes
- Date modified: 09-24-2021 14:39

### Question 5: Web server software?
**Answer**: `LiteSpeed`

### Question 6: Web server version?
**Answer**: `LiteSpeed` (version not explicitly shown in HTTP headers)

### Question 7: Three additional domains downloading malicious files (between 21:45:11 and 21:45:30)?
**Answer**: 
1. `finejewels.com.au` (148.72.192.206)
2. `thietbiagt.com` (210.245.90.247)
3. `new.americold.com` (148.72.53.144)

All three contacted via HTTPS (port 443) within the specified timeframe.

---

## Part 2: Command & Control Activity

### Question 8: Certificate Authority for first domain (finejewels.com.au)?
**Answer**: `Go Daddy Secure Certificate Authority - G2`
- Also listed: Go Daddy Root Certificate Authority - G2
- Frame: 2436

### Question 9: Two Cobalt Strike server IP addresses?
**Answer (Based on Analysis)**:
1. `185.125.204.174` (securitybusinpuff.com, port 8080)
2. `148.72.192.206` (finejewels.com.au, port 443) OR `208.91.128.6` (maldivehost.net, HTTP POST beaconing)

**Analysis Notes**:
- 185.125.204.174 shows high traffic volume (2.4 MB) over 253 seconds
- 208.91.128.6 (maldivehost.net) shows POST request beaconing pattern
- Top traffic destinations include legitimate services (Microsoft, OpenSSL)

### Question 10: Host header for first Cobalt Strike IP?
**Answer**: `securitybusinpuff.com` (for 185.125.204.174)

### Question 11 & 12: Domain names for C2 IPs?
**Answer**:
- IP 185.125.204.174 → `securitybusinpuff.com`
- IP 208.91.128.6 → `maldivehost.net`

### Question 13: Domain for post-infection traffic?
**Answer**: `maldivehost.net`
- IP: 208.91.128.6
- Shows regular POST request beaconing behavior
- 26 POST requests observed

### Question 14: First eleven characters of data sent to C2?
**Answer**: `/zLIisQRWZI`
- Full first URI: /zLIisQRWZI9/OQsaDixzHTgtfjMcGypGenpldWF5eWV9f3k=
- Data appears to be base64 encoded
- Frame: 3822
- Time: 2021-09-24T21:46:16.395000000+0500

### Question 15: Length of first packet to C2?
**Answer**: `281` bytes
- Frame: 3822
- Destination: maldivehost.net (208.91.128.6)

### Question 16: Server header for malicious domain?
**Answer**: `Apache/2.4.49 (cPanel) OpenSSL/1.1.1l mod_bwlimited/1.4`
- Domain: maldivehost.net
- IP: 208.91.128.6

---

## Part 3: Final Exfiltration/Check-in

### Question 17: When did the first DNS query for external IP checking occur?
**Answer**: `2021-09-24 22:00:04`
- Full timestamp: 2021-09-24T22:00:04.093354000+0500

### Question 18: Domain name for external IP checking?
**Answer**: `api.ipify.org`
- Common service used to determine external/public IP address
- Multiple queries observed at 22:00:04, 22:00:59, 22:02:17

### Question 19: Email address from SMTP traffic?
**Answer**: `farshin@mailfa.com`
- Found in SMTP MAIL FROM command
- Frame: 28576
- Additional compromise: ho3ein.sharifi@mailfa.com (Frame: 28804)

### Question 20: Password from SMTP traffic?
**Answer**: `dinamit`
- Found in base64 encoded form: `ZGluYW1pdA==`
- Frame: 28504
- AUTH LOGIN method used
- Username (base64): `ZmFyc2hpbkBtYWlsZmEuY29t` → farshin@mailfa.com

---

## Attack Timeline

**21:44:38** - Initial compromise: documents.zip downloaded from attirenepal.com  
**21:45:11** - Connection to finejewels.com.au (HTTPS)  
**21:45:21** - Connection to thietbiagt.com (HTTPS)  
**21:45:25** - Connection to new.americold.com (HTTPS)  
**21:46:16** - First C2 beaconing to maldivehost.net begins  
**21:46:16 - 21:52:32** - Regular POST beaconing every ~25 seconds  
**22:00:04** - External IP check via api.ipify.org  
**22:00:04+** - SMTP exfiltration using compromised mailfa.com account

---

## Indicators of Compromise (IOCs)

### Malicious Domains
- attirenepal.com (85.187.128.24)
- finejewels.com.au (148.72.192.206)
- thietbiagt.com (210.245.90.247)
- new.americold.com (148.72.53.144)
- securitybusinpuff.com (185.125.204.174)
- maldivehost.net (208.91.128.6)

### Malicious Files
- documents.zip (SHA-256: not extracted)
- chart-1530076591.xls (potential macro malware)

### Compromised Credentials
- Email: farshin@mailfa.com / Password: dinamit
- Email: ho3ein.sharifi@mailfa.com / Password: 13691369 (from base64: MTM2OTEzNjk=)

### Network Indicators
- HTTP POST beaconing to /zLIisQRWZI9/* on maldivehost.net
- Port 8080 traffic to 185.125.204.174
- Regular ~25 second beaconing intervals

---

## Analysis Tools Used
- Wireshark 4.6.0
- TShark (Wireshark) 4.6.0
- macOS terminal utilities (base64, grep, awk)

