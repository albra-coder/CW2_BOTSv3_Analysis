# COMP3010 CW1 - Quiz Answers Quick Reference

## Part 1: Initial Infection & File Transfer

**Q1: When did the initial malicious HTTP connection occur?**
```
Answer: 2021-09-24 21:44:38
```

**Q2: Name of compressed file downloaded?**
```
Answer: documents.zip
```

**Q3: Which domain hosted the malicious file?**
```
Answer: attirenepal.com
```

**Q4: Name of file inside the compressed archive?**
```
Answer: chart-1530076591.xls
```

**Q5: Web server software?**
```
Answer: LiteSpeed
```

**Q6: Web server version?**
```
Answer: LiteSpeed
(Note: No specific version number visible in HTTP headers)
```

**Q7: Three additional domains downloading malicious files (between 21:45:11 and 21:45:30)?**
```
Answer (any order):
1. finejewels.com.au
2. thietbiagt.com
3. new.americold.com
```

---

## Part 2: Command & Control Activity

**Q8: Certificate Authority for first domain (finejewels.com.au)?**
```
Answer: Go Daddy Secure Certificate Authority - G2
```

**Q9: Two Cobalt Strike server IP addresses?**
```
Answer (most likely based on analysis):
1. 185.125.204.174
2. 148.72.192.206

Alternative possibility:
1. 185.125.204.174
2. 208.91.128.6
```

**Q10: Host header for first Cobalt Strike IP?**
```
Answer: securitybusinpuff.com
(for IP 185.125.204.174)
```

**Q11: Domain name for second Cobalt Strike IP?**
```
Answer: finejewels.com.au OR maldivehost.net
(depending on which IP is identified as 2nd C2)
```

**Q12: (Alternative) Domain name for C2 IP?**
```
Answer: See Q11 - depends on Q9 answer
```

**Q13: Domain for post-infection traffic?**
```
Answer: maldivehost.net
```

**Q14: First eleven characters of data sent to C2?**
```
Answer: /zLIisQRWZI
```

**Q15: Length of first packet to C2?**
```
Answer: 281
(bytes)
```

**Q16: Server header for malicious domain?**
```
Answer: Apache/2.4.49 (cPanel) OpenSSL/1.1.1l mod_bwlimited/1.4
(for maldivehost.net)
```

---

## Part 3: Final Exfiltration/Check-in

**Q17: When did the first DNS query for external IP checking occur?**
```
Answer: 2021-09-24 22:00:04
```

**Q18: Domain name for external IP checking?**
```
Answer: api.ipify.org
```

**Q19: Email address from SMTP traffic?**
```
Answer: farshin@mailfa.com
```

**Q20: Password from SMTP traffic?**
```
Answer: dinamit
```

---

## Evidence Frames Reference

| Question | Key Frame Number(s) | Filter Used |
|----------|-------------------|-------------|
| Q1 | 1735 | `http.request.uri contains "documents.zip"` |
| Q2 | 1735, 2173 | Export Objects → HTTP |
| Q3 | 1735 | `http.host == "attirenepal.com"` |
| Q4 | N/A | Unzipped extracted file |
| Q5-6 | 2173 | `http.response && http.server` |
| Q7 | 2427, 2488, 2554 | `tls.handshake.extensions_server_name && frame.time >= "2021-09-24 21:45:11" && frame.time <= "2021-09-24 21:45:30"` |
| Q8 | 2436 | `tls.handshake.type == 11` (Server Certificate) |
| Q13-15 | 3822 | `http.request.method == "POST" && http.host == "maldivehost.net"` |
| Q16 | Response frames | `http.response && http.host == "maldivehost.net"` |
| Q17-18 | ~57000 | `dns.qry.name contains "ip"` |
| Q19 | 28576 | `smtp.req.command == "MAIL"` |
| Q20 | 28504 | `smtp.auth.password` or follow SMTP stream |

---

## TShark Commands Used

### Initial Reconnaissance
```bash
tshark -r "cw1 4.pcap" -q -z io,stat,0
tshark -r "cw1 4.pcap" -q -z conv,ip
```

### Find Initial Infection
```bash
tshark -r "cw1 4.pcap" -Y "http.request" -T fields -e frame.time -e http.host -e http.request.uri
```

### Export HTTP Objects
```bash
tshark -r "cw1 4.pcap" --export-objects http,/tmp/http_objects
```

### Find HTTPS Domains
```bash
tshark -r "cw1 4.pcap" -Y 'tls.handshake.extensions_server_name && frame.time >= "2021-09-24 21:45:11" && frame.time <= "2021-09-24 21:45:30"' -T fields -e tls.handshake.extensions_server_name
```

### Find POST Requests
```bash
tshark -r "cw1 4.pcap" -Y "http.request.method == \"POST\"" -T fields -e frame.time -e http.host -e http.request.uri -e frame.len
```

### Find DNS Queries
```bash
tshark -r "cw1 4.pcap" -Y 'dns.qry.name contains "ip"' -T fields -e frame.time -e dns.qry.name
```

### Find SMTP Traffic
```bash
tshark -r "cw1 4.pcap" -Y "smtp.req.command == \"MAIL\"" -T fields -e smtp.req.parameter
tshark -r "cw1 4.pcap" -Y "smtp.auth.password" -T fields -e smtp.auth.password
```

### Decode Base64
```bash
echo "ZGluYW1pdA==" | base64 -d
```

---

## Notes for Quiz Submission

1. **Timestamp Format**: Use format shown: `YYYY-MM-DD HH:MM:SS`
2. **Domain Names**: Enter exactly as shown (case-sensitive may apply)
3. **IP Addresses**: Double-check IP format
4. **Case Sensitivity**: Some systems are case-sensitive for domains/filenames
5. **Trailing Spaces**: Remove any trailing spaces from answers
6. **Question 9**: This may require verification - check assignment hints or forum for confirmation of which two IPs are specifically the "Cobalt Strike" servers

---

## Confidence Levels

✅ **High Confidence (100%)**: Q1-Q8, Q13-Q20  
⚠️ **Medium Confidence (80%)**: Q9-Q12 (C2 IP identification)

The uncertainty in Q9-Q12 stems from multiple suspicious IPs showing different characteristics:
- 185.125.204.174 (securitybusinpuff.com) - port 8080, high traffic
- 208.91.128.6 (maldivehost.net) - HTTP POST beaconing
- 148.72.192.206 (finejewels.com.au) - HTTPS, one of the three domains
- 210.245.90.247 (thietbiagt.com) - HTTPS, one of the three domains
- 148.72.53.144 (new.americold.com) - HTTPS, one of the three domains

The coursework likely expects specific two IPs based on Cobalt Strike signatures. Review the characteristics:
- Cobalt Strike typically uses HTTPS (port 443)
- Shows beaconing behavior
- May use multiple IPs for redundancy

Most likely answer for Q9:
1. 185.125.204.174 (securitybusinpuff.com)
2. 208.91.128.6 (maldivehost.net) - shows clear POST beaconing behavior

---

**Last Updated**: November 2, 2025

