# Incident Analysis Report: Network Intrusion Investigation

**Module:** COMP3010 Security Operations & Incident Management  
**Student Name:** [Your Name]  
**Student ID:** [Your ID]  
**Date:** [Date]  
**Word Count:** [XXX/1000]

---

## 1. Introduction

[150-200 words]

This report documents a comprehensive forensic analysis of network traffic captured during a suspected security incident. The investigation focuses on identifying the compromised system, determining the attack vector, and characterizing the nature of the intrusion.

**Objectives:**
- Identify the infected system and user
- Determine how the infection occurred
- Analyze the type and behavior of the malware
- Extract indicators of compromise (IOCs)
- Recommend prevention strategies

**Report Structure:**
- Section 2 describes the methodology and tools employed
- Section 3 presents the detailed findings from the analysis
- Section 4 concludes with recommendations for preventing similar incidents

**Scope:**
- Time period analyzed: [start] to [end]
- Network segment: [description]
- Data source: PCAP file containing [X] packets over [Y] protocols

[Add more context about what you're investigating]

---

## 2. Methodology

[300-350 words]

### 2.1 Tools and Environment

The analysis was conducted using the following tools and environment:

**Primary Analysis Tool:**
- Wireshark version [X.X.X] on macOS [version]
- tshark command-line interface for batch processing and scripting

**Supporting Tools:**
- [Any other tools you used]

**Analysis Environment:**
- Operating System: macOS [version]
- Working Directory: Organized folder structure for evidence management
- Screenshot Management: Systematic capture and annotation of key findings

### 2.2 Analysis Approach

The investigation followed a structured three-phase methodology:

**Phase 1: Initial Reconnaissance (Overview Analysis)**
- Packet capture statistics gathering
- Protocol hierarchy analysis
- Identification of communication patterns
- Timeline establishment

*Evidence:* [Reference screenshot showing statistics/overview]

**Phase 2: Timeline Construction**
- Chronological mapping of network events
- Identification of key inflection points
- Correlation of related activities

**Phase 3: Detailed Examination**
- Deep packet inspection
- Stream reconstruction
- Object extraction and analysis
- Certificate and header examination

### 2.3 Specific Techniques Applied

**Display Filtering:**
Applied systematic display filters to isolate relevant traffic:
```
http.request           # HTTP requests
http.request.method == "GET"  # File downloads
tls.handshake.extensions_server_name  # HTTPS domains
dns                    # DNS queries
smtp                   # Email traffic
```

*Evidence:* [Screenshot showing filter application in Wireshark]

**Stream Following:**
Used TCP/HTTP stream following to reconstruct complete conversations between hosts, particularly useful for analyzing:
- HTTP POST data sent to C2 servers
- SMTP conversations revealing credentials
- Complete request/response pairs

*Evidence:* [Screenshot of Follow Stream window]

**Object Extraction:**
Utilized Wireshark's Export Objects functionality to extract files transferred via HTTP, enabling:
- Identification of downloaded malware
- Analysis of file metadata
- Hash generation for IOC documentation

*Evidence:* [Screenshot of Export Objects window]

**Certificate Analysis:**
Examined TLS certificates to:
- Identify Certificate Authorities
- Extract domain information from certificates
- Verify or identify suspicious certificates

*Evidence:* [Screenshot showing certificate details]

---

## 3. Results

[400-450 words]

### 3.1 Infected System Identification

Through analysis of ARP, DHCP, and application-layer protocols, the infected system was identified as:

- **IP Address:** [IP]
- **MAC Address:** [MAC]
- **Hostname:** [hostname]
- **User Account:** [username]

*Evidence:* [Screenshot showing system identification]

**Rationale:** [Explain how you determined this was the infected system - e.g., it initiated all malicious connections, downloaded suspicious files, etc.]

### 3.2 Initial Compromise

**Infection Timeline:**
The initial malicious activity was observed at **[exact timestamp]** when the infected system initiated an HTTP GET request to download a compressed file.

**Downloaded File:**
- Filename: [filename]
- Source Domain: [domain]
- Source IP: [IP]
- File Size: [size]
- File Type: [type]

*Evidence:* [Screenshot of HTTP request and Export Objects window]

**Web Server Information:**
The malicious file was served by:
- Server Software: [software name]
- Server Version: [version]
- Significance: [Why this matters]

*Evidence:* [Screenshot of Server header]

**Archive Contents:**
Upon extraction, the compressed file contained:
- [filename and description]

This file was identified as [type of malware/script/executable].

### 3.3 Secondary Malicious Downloads

Between **16:45:11 and 16:45:30**, the infected system contacted three additional domains to download further malicious components:

1. **[domain1]** - [description]
2. **[domain2]** - [description]  
3. **[domain3]** - [description]

*Evidence:* [Screenshot showing TLS connections with SNI fields during this timeframe]

**Certificate Authority Analysis:**
The SSL certificate for [first domain] was issued by **[CA name]**, which [is/is not] a legitimate Certificate Authority. [Analysis of whether this is suspicious]

*Evidence:* [Screenshot of certificate details]

### 3.4 Command & Control (C2) Communication

**C2 Infrastructure:**
Analysis of network conversations revealed two Cobalt Strike C2 servers:

**Server 1:**
- IP Address: [IP1]
- Domain: [domain1]
- Host Header: [host header]
- Communication Pattern: [description]

**Server 2:**
- IP Address: [IP2]
- Domain: [domain2]
- Communication Method: [HTTP/HTTPS]
- Server Software: [from Server header]

*Evidence:* [Screenshot of Conversations statistics and C2 traffic]

**Cobalt Strike Indicators:**
The traffic exhibited characteristic Cobalt Strike behavior:
- Regular beaconing pattern to C2 servers
- HTTPS connections on port 443
- HTTP POST requests containing encrypted/encoded data
- Specific User-Agent strings: [if applicable]

**Post-Infection Traffic Analysis:**
The primary post-infection domain used for command and control was **[domain]**.

The infected system sent data to this domain beginning with: **[first 11 characters]**

The first packet sent to the C2 server had a length of **[length] bytes**.

*Evidence:* [Screenshot of POST requests and Follow Stream showing data]

### 3.5 Exfiltration and External Communication

**External IP Resolution:**
At **[timestamp UTC]**, the malware queried **[domain]** to determine the infected system's external IP address. This is a common technique used by malware to report the victim's public IP to the C2 server.

*Evidence:* [Screenshot of DNS query]

**Email Communication (SMTP):**
SMTP traffic analysis revealed attempted email communications:
- Source Email: **[email address]**
- Credentials compromised: Username **ho3ein.sharifi** with password **[password]**

*Evidence:* [Screenshot of SMTP traffic and Follow Stream]

**Security Implication:** The exposure of email credentials suggests potential for:
- Lateral phishing attacks
- Data exfiltration via email
- Further compromise of related accounts

### 3.6 Complete Attack Chain Summary

The attack progressed through the following stages:

1. **Initial Access** ([time]): Victim downloaded malicious file from [domain]
2. **Execution** ([time]): Compressed archive extracted and payload executed
3. **Persistence** ([time]): Additional components downloaded from multiple domains
4. **Command & Control** ([time]): Established connections to two Cobalt Strike servers
5. **Discovery** ([time]): Malware determined external IP address
6. **Credential Access** ([time]): Email credentials observed in network traffic
7. **Exfiltration** ([time-ongoing]): Regular C2 beaconing and data transfer

---

## 4. Conclusion and Recommendations

[150-200 words]

### 4.1 Summary of Findings

This investigation successfully identified a multi-stage intrusion involving:
- Initial compromise via malicious file download
- Deployment of Cobalt Strike post-exploitation framework
- Establishment of persistent C2 communications
- Credential exposure and potential data exfiltration

The infected system [IP/hostname] was thoroughly compromised, with the attacker maintaining ongoing access through two C2 servers.

### 4.2 Immediate Response Actions

**Recommended immediate actions:**
1. **Isolate** the infected system ([IP]) from the network
2. **Block** the identified malicious domains and IPs at the firewall/proxy
3. **Reset** credentials for user account [username] and email [email]
4. **Scan** the network for other systems communicating with the C2 infrastructure
5. **Preserve** forensic evidence for potential legal action

### 4.3 Prevention Recommendations

To prevent similar incidents in the future, the following controls should be implemented:

**Technical Controls:**

1. **Network Security:**
   - Deploy next-generation firewall with TLS inspection capabilities
   - Implement DNS filtering to block known malicious domains
   - Configure intrusion detection/prevention systems (IDS/IPS) with Cobalt Strike signatures
   - Enable network segmentation to limit lateral movement

2. **Endpoint Protection:**
   - Deploy endpoint detection and response (EDR) solution
   - Enable application whitelisting to prevent unauthorized executables
   - Implement email security gateway with sandboxing for attachments
   - Enforce regular patching and update schedules

3. **Monitoring:**
   - Establish Security Operations Center (SOC) or security monitoring capability
   - Configure alerts for:
     - Large outbound data transfers
     - Connections to newly registered domains
     - Unusual HTTPS beacon patterns
     - Anomalous DNS queries

**Policy and Training:**

1. **User Awareness:**
   - Security awareness training emphasizing risks of:
     - Downloading files from untrusted sources
     - Opening unexpected email attachments
     - Clicking on suspicious links
   - Regular phishing simulation exercises

2. **Access Control:**
   - Implement principle of least privilege
   - Use multi-factor authentication (MFA) for all accounts
   - Regular access reviews and credential rotation

3. **Incident Response:**
   - Develop and test incident response procedures
   - Establish clear escalation paths
   - Conduct regular tabletop exercises

### 4.4 Open Issues and Challenges

**Limitations of this analysis:**
- Initial infection vector unclear - how did the user access the malicious domain?
- Full scope of data exfiltration unknown without decrypting TLS traffic
- Potential lateral movement to other systems requires further investigation

**Questions for follow-up:**
- Were any other systems in the network compromised?
- What data, if any, was successfully exfiltrated?
- How long was the attacker present before detection?

---

## References

[1] Wireshark Foundation, "Wireshark User's Guide," Available: https://www.wireshark.org/docs/

[2] MITRE ATT&CK, "Cobalt Strike, Software S0154," Available: https://attack.mitre.org/software/S0154/

[3] NIST, "Computer Security Incident Handling Guide," SP 800-61 Rev. 2, 2012.

[4] SANS Institute, "Intrusion Detection FAQ: Network Intrusion Detection Systems," Available: https://www.sans.org/

[5] Cisco, "Cisco Talos Intelligence Group - Cobalt Strike Analysis," Available: https://www.talosintelligence.com/

[Add any other sources you referenced]

---

## Appendices

### Appendix A: Indicators of Compromise (IOCs)

**Malicious Domains:**
```
[domain1]
[domain2]
[domain3]
[...]
```

**Malicious IP Addresses:**
```
[IP1]
[IP2]
```

**Malicious Files:**
```
Filename: [name]
MD5: [hash if available]
SHA256: [hash if available]
```

### Appendix B: Generative AI Declaration

**AI Usage Declaration:**

I declare that I used the following generative AI tools during the completion of this coursework:

**Tool(s) Used:** ChatGPT / Claude / [other]

**Purpose of Use:**
- Understanding technical concepts (Cobalt Strike, C2 infrastructure, etc.)
- Learning Wireshark filter syntax
- Assistance with report structure and grammar
- Debugging command-line tool usage
- [List specific uses]

**Scope of AI Assistance:**
All packet analysis, investigation, and conclusions are my own work based on my personal examination of the provided PCAP file. AI tools were used only for learning concepts and improving presentation, not for performing the analysis or generating answers to the quiz questions.

**Signature:** [Your Name]  
**Date:** [Date]

---

**End of Report**

