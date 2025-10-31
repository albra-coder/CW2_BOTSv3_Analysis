# CW1 Quiz Answers Tracker

**Instructions:** Fill in your answers as you find them. Include the evidence/method you used.

---

## Part 1: Initial Infection & File Transfer

### Question 1: When did the initial malicious HTTP connection occur?
**Format:** yyyy-mm-dd hh:mm:ss

**Answer:** 

**How I found it:**
- Filter used: 
- Evidence location: 
- Screenshot: 

---

### Question 2: What is the name of the compressed file that the victim downloaded?

**Answer:** 

**How I found it:**
- Method: File → Export Objects → HTTP
- Evidence: 
- Screenshot: 

---

### Question 3: Which domain hosted the malicious compressed file?

**Answer:** 

**How I found it:**
- Filter used: 
- Packet number: 
- Screenshot: 

---

### Question 4: What is the name of the file located inside the compressed archive?

**Answer:** 

**How I found it:**
- Method: Extracted and unzipped the file
- Evidence: 
- Screenshot: 

---

### Question 5: Identify the specific web server software running on the malicious IP

**Answer:** 

**How I found it:**
- Filter used: http.response
- Server header value: 
- Screenshot: 

---

### Question 6: What is the version number of the web server?

**Answer:** 

**How I found it:**
- From Server header: 
- Screenshot: 

---

### Question 7: Identify the three additional domains downloading malicious files
**Time window:** Between 16:45:11 and 16:45:30
**Hint:** Look at HTTPS traffic and SNI fields

**Answer 1:** 
**Answer 2:** 
**Answer 3:** 

**How I found them:**
- Filter used: frame.time >= "..." && frame.time <= "..." && tls
- Method: Looked at TLS Client Hello → Server Name Indication
- Screenshot: 

---

## Part 2: Command and Control (C2) Activity

### Question 8: Which Certificate Authority issued the SSL certificate for the first domain from Q7?

**Answer:** 

**How I found it:**
- Filter used: tls.handshake.type == 11
- Located: Certificate → Issuer → CN=
- Screenshot: 

---

### Question 9: What are the two IP addresses of the Cobalt Strike servers?
**Hint:** Statistics → Conversations

**Answer 1:** 
**Answer 2:** 

**How I found them:**
- Method: Statistics → Conversations → IPv4
- Looked for: Regular HTTPS traffic, moderate consistent bytes
- Screenshot: 

---

### Question 10: Value of the Host header for the first Cobalt Strike IP?

**Answer:** 

**How I found it:**
- Filter used: ip.addr == [IP] && http
- Located: HTTP request → Host header
- Screenshot: 

---

### Question 11: Domain name associated with the first Cobalt Strike IP?

**Answer:** 

**How I found it:**
- Filter used: dns or tls.handshake.extensions_server_name
- Screenshot: 

---

### Question 12: Domain name associated with the second Cobalt Strike IP?
**Hint:** Look at HTTP POST requests

**Answer:** 

**How I found it:**
- Filter used: http.request.method == POST
- Screenshot: 

---

### Question 13: Domain name used for the post-infection traffic?

**Answer:** 

**How I found it:**
- Filter used: 
- Looked for: Repeating POST requests (beaconing pattern)
- Screenshot: 

---

### Question 14: First eleven characters of data sent to C2 domain from Q13?

**Answer:** 

**How I found it:**
- Method: Follow TCP Stream
- Located: POST data payload
- Screenshot: 

---

### Question 15: Length of the first packet the victim sent to C2 server?

**Answer:** 

**How I found it:**
- Located packet: 
- Frame Length field: 
- Screenshot: 

---

### Question 16: Server header value for the malicious domain from Q13?

**Answer:** 

**How I found it:**
- Filter used: http.response && http.host == "..."
- Screenshot: 

---

## Part 3: Final Exfiltration/Check-in

### Question 17: Date and time when DNS query occurred for external IP check
**Format:** yyyy-mm-dd hh:mm:ss UTC

**Answer:** 

**How I found it:**
- Filter used: dns
- Looked for: IP checking services (api.ipify.org, checkip.amazonaws.com, etc.)
- Screenshot: 

---

### Question 18: Domain name in the DNS query from Q17?

**Answer:** 

**How I found it:**
- Same packet as Q17
- DNS query name field: 
- Screenshot: 

---

### Question 19: First email address in SMTP traffic (MAIL FROM)?

**Answer:** 

**How I found it:**
- Filter used: smtp
- Located: MAIL FROM command
- Screenshot: 

---

### Question 20: ho3ein.sharifi's password?
**Hint:** Follow the SMTP stream from Q19

**Answer:** 

**How I found it:**
- Method: Right-click SMTP packet → Follow → TCP Stream
- Located: AUTH LOGIN or plaintext credentials
- May need to decode base64: 
- Screenshot: 

---

## Summary of Key Findings

### Infected System Information
- **IP Address:** 
- **MAC Address:** 
- **Hostname:** 
- **User Account:** 

### Attack Timeline
1. **[Time]** - Initial malicious download
2. **[Time]** - C2 connection established
3. **[Time]** - Data exfiltration began

### Indicators of Compromise (IOCs)
**Malicious Domains:**
- 
- 
- 

**Malicious IPs:**
- 
- 

**Malicious Files:**
- 
- 

---

## Evidence Checklist

- [ ] Screenshot: Initial HTTP download
- [ ] Screenshot: Downloaded file in Export Objects
- [ ] Screenshot: Server header
- [ ] Screenshot: TLS domains (16:45:11-16:45:30 window)
- [ ] Screenshot: Certificate Authority
- [ ] Screenshot: Conversations showing C2 IPs
- [ ] Screenshot: Host headers for C2 servers
- [ ] Screenshot: POST requests showing beaconing
- [ ] Screenshot: DNS query for IP check service
- [ ] Screenshot: SMTP traffic with email
- [ ] Screenshot: Follow stream showing password

---

## Notes and Observations

[Space for your additional notes, observations, or questions]

