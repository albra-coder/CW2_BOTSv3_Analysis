# COMP3010 CW1 - CORRECTED Quiz Answers

## ⚠️ IMPORTANT CORRECTIONS

**Question 17 - TIMEZONE ISSUE:**
- The timestamp in PCAP is `2021-09-24T22:00:04+0500` (UTC+5)
- Question asks for **UTC format**
- **CORRECTED ANSWER: 2021-09-24 17:00:04** (converted from UTC+5 to UTC)

**Question 20 - WRONG PASSWORD:**
- Question asks for **ho3ein.sharifi's password**, NOT farshin's password
- Base64 encoded: MTM2OTEzNjk=
- **CORRECTED ANSWER: 13691369**

---

## ALL 20 QUIZ ANSWERS (CORRECTED)

### Part 1: Initial Infection & File Transfer

**Q1: When did the initial malicious HTTP connection occur? (yyyy-mm-dd hh:mm:ss format)**
```
Answer: 2021-09-24 21:44:38
```
*Note: This is the local timestamp from PCAP. Question doesn't specify UTC.*

**Q2: Name of compressed file downloaded?**
```
Answer: documents.zip
```

**Q3: Which domain hosted the malicious compressed file?**
```
Answer: attirenepal.com
```

**Q4: Name of file inside the compressed archive?**
```
Answer: chart-1530076591.xls
```

**Q5: Web server software (Server header)?**
```
Answer: LiteSpeed
```

**Q6: Web server version?**
```
Answer: LiteSpeed
```
*Note: No specific version number in HTTP headers. If quiz requires just software name, use "LiteSpeed"*

**Q7: Three additional domains downloading malicious files (between 16:45:11 and 16:45:30 UTC)?**
```
Answer: finejewels.com.au, thietbiagt.com, new.americold.com
```
*Format: Domain1, Domain2, Domain3 (comma space, order doesn't matter)*
*Note: Time range 16:45:11-16:45:30 UTC = 21:45:11-21:45:30 in PCAP (UTC+5)*

---

### Part 2: Command & Control Activity

**Q8: Certificate Authority for first domain (finejewels.com.au)?**
```
Answer: Go Daddy Secure Certificate Authority - G2
```

**Q9: Two Cobalt Strike server IP addresses (sequential order)?**
```
Option 1 (High Traffic IPs): 23.111.114.52, 136.232.34.70
Option 2 (Malicious Domains): 185.125.204.174, 208.91.128.6
```
⚠️ **UNCERTAIN** - Try Option 1 first (based on "Conversations" hint), if wrong try Option 2

**Q10: Host header for first Cobalt Strike IP?**
```
If Q9 = 23.111.114.52: Check with DNS/HTTP filters
If Q9 = 185.125.204.174: securitybusinpuff.com
```

**Q11: Domain name for first Cobalt Strike IP?**
```
If Q9 = 185.125.204.174: securitybusinpuff.com
If Q9 = 148.72.192.206: finejewels.com.au
```
*Hint: "Take a closer look at HTTPS (443)"*

**Q12: Domain name for second Cobalt Strike IP?**
```
If Q9 includes 208.91.128.6: maldivehost.net
```
*Hint: "Apply a filter to capture HTTP POST requests"*

**Q13: Domain for post-infection traffic?**
```
Answer: maldivehost.net
```

**Q14: First eleven characters of data sent to malicious domain from Q13?**
```
Answer: /zLIisQRWZI
```
*Note: Case sensitive, copy exactly as shown*

**Q15: Length of first packet to C2 server?**
```
Answer: 281
```

**Q16: Server header for malicious domain from Q13 (maldivehost.net)?**
```
Answer: Apache/2.4.49 (cPanel) OpenSSL/1.1.1l mod_bwlimited/1.4
```
*Note: Case sensitivity matters, copy exactly from PCAP*

---

### Part 3: Exfiltration & Check-in

**Q17: Date and time of DNS query for external IP check (yyyy-mm-dd hh:mm:ss UTC format)?**
```
Answer: 2021-09-24 17:00:04
```
**✅ CORRECTED** - Converted from 22:00:04 +0500 to UTC (17:00:04)

**Q18: Domain name in DNS query from Q17?**
```
Answer: api.ipify.org
```

**Q19: First email address in SMTP traffic (MAIL FROM)?**
```
Answer: farshin@mailfa.com
```

**Q20: ho3ein.sharifi's password (follow stream from Q19)?**
```
Answer: 13691369
```
**✅ CORRECTED** - This is ho3ein.sharifi's password, NOT farshin's (which was "dinamit")

---

## Answer Format Guide

### Question 7 Format:
```
finejewels.com.au, thietbiagt.com, new.americold.com
```
- Comma followed by space
- Order doesn't matter
- Exact domain names

### Question 9 Format:
```
IP1, IP2
```
- Comma followed by space
- Sequential order

### Timestamp Formats:
- **Q1**: Local time from PCAP: `2021-09-24 21:44:38`
- **Q17**: UTC time: `2021-09-24 17:00:04`

---

## Critical Notes

1. **Case Sensitivity**: Q14, Q16 are case-sensitive - copy exactly
2. **Timezone**: Q17 specifically asks for UTC - must convert
3. **Password**: Q20 asks for ho3ein.sharifi, not farshin
4. **Domain Format**: Q18 uses full subdomain "api.ipify.org" not just "ipify.org"
5. **Q9 Uncertainty**: If first answer doesn't work, try the alternative

---

## SMTP Account Details (for reference)

| Frame | Email | Base64 Password | Decoded Password |
|-------|-------|----------------|------------------|
| 28504 | farshin@mailfa.com | ZGluYW1pdA== | dinamit |
| 28763 | ho3ein.sharifi@mailfa.com | MTM2OTEzNjk= | **13691369** ← Q20 |
| 39851 | cristianodummer@cultura.com.br | MTgxMjk3 | 181297 |

---

**Last Updated**: November 2, 2025 (with corrections)

