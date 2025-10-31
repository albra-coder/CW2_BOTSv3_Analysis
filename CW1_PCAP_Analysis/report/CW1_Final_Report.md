# Network Forensics Analysis: Investigation of Malware Infection

**COMP3010 Coursework 1**  
**Student Name**: [Your Name]  
**Student ID**: [Your ID]  
**Date**: November 2, 2025  
**Word Count**: ~980 words

---

## 1. Introduction

This incident analysis report documents a comprehensive forensic examination of network traffic captured during a suspected security breach on September 24, 2021. The analysis focuses on identifying the infected system, determining the infection vector, characterizing the nature of the compromise, and documenting indicators of compromise (IOCs) for future threat detection and prevention.

The investigation employs packet-level analysis techniques using Wireshark and TShark to examine HTTP, HTTPS, DNS, and SMTP traffic patterns captured in a PCAP file spanning approximately 21 minutes (70,873 packets, 54.9 MB). The victim system (10.9.23.102, hostname DESKTOP-IOJC6RB) on the goingfortune.com domain was compromised through a malicious file download, followed by command and control (C2) establishment and data exfiltration.

This report is structured as follows: Section 2 describes the methodology employed in the analysis, Section 3 presents detailed findings organized by attack phase, and Section 4 concludes with prevention recommendations and lessons learned from this incident.

---

## 2. Methodology

### 2.1 Tools and Environment

The analysis was conducted on macOS 14.4 using Wireshark version 4.6.0 and its command-line equivalent, TShark. Additional Unix utilities including grep, awk, and base64 were employed for data extraction and decoding. The working environment was organized into structured directories for PCAP files, exported objects, analysis results, and report documentation to maintain systematic evidence handling.

### 2.2 Analysis Approach

The investigation followed a three-phase methodology designed to progressively understand the incident from reconnaissance through detailed examination:

**Phase 1: Initial Reconnaissance (30 minutes)** - Statistical analysis was performed to understand the capture's temporal scope, identify internal versus external IP addresses, and examine protocol hierarchy. The command `tshark -r file.pcap -q -z io,stat,0` provided baseline statistics, while conversation analysis (`tshark -q -z conv,ip`) identified the victim system and primary communication partners.

**Phase 2: Timeline Construction (60 minutes)** - A chronological timeline of significant events was developed by filtering HTTP requests, DNS queries, and HTTPS connections. Display filters such as `http.request.method == "GET"` and `tls.handshake.extensions_server_name` revealed the sequence of malicious activities from initial infection through data exfiltration.

**Phase 3: Detailed Packet Examination (90 minutes)** - Targeted analysis of suspicious traffic using protocol-specific filters, stream following, object extraction, and certificate inspection. For example, HTTP objects were exported using `tshark --export-objects http,directory`, SMTP credentials were decoded from base64 encoding, and TLS certificate chains were examined to identify certificate authorities.

### 2.3 Specific Techniques Applied

**Protocol Filtering**: Systematic application of Wireshark display filters to isolate relevant traffic types. Key filters included `http.request.uri contains ".zip"` for malicious downloads, `http.request.method == "POST"` for C2 beaconing, `dns.qry.name contains "ip"` for external IP reconnaissance, and `smtp.req.command == "MAIL"` for exfiltration analysis.

**Stream Reconstruction**: TCP stream following was employed to reconstruct complete conversations between the victim and suspicious hosts, particularly useful for analyzing HTTP POST data to C2 servers and SMTP authentication sequences.

**Object Extraction**: Files transferred via HTTP were extracted and analyzed, including documents.zip (193 KB) and its contained Excel file chart-1530076591.xls, which likely contained malicious macros initiating the infection chain.

**Temporal Analysis**: Frame timestamps were carefully examined to establish causality and sequence of events, critical for distinguishing initial infection from subsequent C2 activity and exfiltration.

---

## 3. Results

### 3.1 Initial Compromise

The infection chain began at **21:44:38 on September 24, 2021** when the victim system (10.9.23.102) downloaded documents.zip from attirenepal.com (85.187.128.24) via HTTP GET request to `/incidunt-consequatur/documents.zip`. The file, hosted on a LiteSpeed web server, contained chart-1530076591.xls, a 251 KB Excel file likely weaponized with malicious macros.

Evidence of this initial infection is found in frame 1735, which shows the HTTP GET request, and the subsequent HTTP 200 OK response in frame 2173 with server header "LiteSpeed". The compressed archive was successfully extracted from the packet capture using Wireshark's Export Objects feature, confirming the filename and contents.

### 3.2 Secondary Infections and Staging

Following the initial compromise, the victim system established HTTPS connections to three additional malicious domains within a 19-second window (21:45:11 to 21:45:30):

1. **finejewels.com.au** (148.72.192.206) at 21:45:11 - TLS certificate issued by Go Daddy Secure Certificate Authority - G2
2. **thietbiagt.com** (210.245.90.247) at 21:45:21  
3. **new.americold.com** (148.72.53.144) at 21:45:25

These HTTPS connections on port 443 likely downloaded additional malware components or staged files for persistence. The use of legitimate-looking domain names (jewelry retailer, equipment supplier, cold storage company) suggests compromised legitimate websites being leveraged for malware distribution. Total traffic to these three hosts involved 279 HTTPS packets, indicating substantial data transfer beyond simple DNS resolution.

### 3.3 Command and Control Establishment

The malware established C2 communication through two distinct channels:

**Primary C2: maldivehost.net** (208.91.128.6) - Beginning at 21:46:16, the victim initiated regular HTTP POST beaconing to this domain running Apache/2.4.49 (cPanel) OpenSSL/1.1.1l. The beaconing pattern showed 26 POST requests at approximately 25-second intervals to URIs formatted as `/zLIisQRWZI9/[base64-encoded-data]`. The first 11 characters of C2 data were "/zLIisQRWZI", with the initial packet measuring 281 bytes. This classic beaconing behavior is characteristic of Cobalt Strike or similar post-exploitation frameworks.

**Secondary C2: securitybusinpuff.com** (185.125.204.174) - This domain showed 2,923 packets totaling 2.4 MB over 253 seconds, primarily using port 8080. The high traffic volume and sustained connection duration suggest this may have been used for data staging or secondary payload delivery.

Analysis of the POST request contents revealed base64-encoded payloads, likely containing encrypted commands and system reconnaissance data being exfiltrated to the attacker's C2 infrastructure.

### 3.4 Post-Exploitation Activity

The malware performed several post-exploitation activities:

**External IP Reconnaissance**: At 22:00:04, multiple DNS queries to api.ipify.org were observed, a common technique for malware to determine the victim's public-facing IP address for reporting back to attackers.

**Credential Theft and Email Exfiltration**: SMTP traffic analysis revealed compromised email credentials being used for data exfiltration. Frame 28576 contained `MAIL FROM:<farshin@mailfa.com>`, and subsequent frames revealed AUTH LOGIN authentication with base64-encoded credentials. Decoding revealed:
- Username: farshin@mailfa.com
- Password: dinamit

Additional compromised credentials were found for ho3ein.sharifi@mailfa.com (password: 13691369), suggesting either lateral movement or access to a credential database. The use of these compromised accounts for SMTP communication indicates the malware was attempting to exfiltrate data or establish persistent command channels via email.

### 3.5 Victim Profile

The compromised system exhibited the following characteristics:
- **IP Address**: 10.9.23.102 (internal network)
- **Hostname**: DESKTOP-IOJC6RB
- **Domain**: goingfortune.com
- **Operating System**: Windows (based on hostname format and SMB/CLDAP traffic)
- **Network Position**: Internal workstation with internet access through gateway 10.9.23.1
- **DNS Server**: 10.9.23.5 (goingfortune-dc.goingfortune.com)

---

## 4. Conclusion and Prevention

### 4.1 Summary of Findings

This investigation documented a sophisticated multi-stage malware infection initiated through a malicious Excel file delivered via HTTP download. The attack progressed through distinct phases: initial compromise via documents.zip, secondary staging through three HTTPS domains, C2 establishment with beaconing behavior, external IP reconnaissance, and credential-based exfiltration via SMTP. The malware demonstrated advanced characteristics including base64-encoded C2 communications, regular beaconing patterns consistent with Cobalt Strike, and multi-channel command infrastructure.

### 4.2 Indicators of Compromise

**Network IOCs**: attirenepal.com (85.187.128.24), finejewels.com.au (148.72.192.206), thietbiagt.com (210.245.90.247), new.americold.com (148.72.53.144), securitybusinpuff.com (185.125.204.174), maldivehost.net (208.91.128.6)

**File IOCs**: documents.zip, chart-1530076591.xls

**Behavioral IOCs**: POST beaconing to /zLIisQRWZI9/* paths, 25-second beacon intervals, base64-encoded URI parameters, DNS queries to api.ipify.org

### 4.3 Prevention Recommendations

**Network Security Controls**:
- Deploy intrusion detection systems (IDS) configured to detect Cobalt Strike beaconing patterns, particularly regular HTTP POST requests with base64-encoded URIs
- Implement DNS filtering to block known malicious domains and IP checking services commonly used by malware
- Deploy web content filtering to prevent downloads of executable content and archives from untrusted domains
- Enable SSL/TLS inspection to examine encrypted HTTPS traffic for malicious payloads

**Endpoint Protection**:
- Implement application whitelisting to prevent unauthorized executable content
- Deploy endpoint detection and response (EDR) solutions with behavioral analysis capabilities to detect post-exploitation activities
- Enforce macro security policies in Microsoft Office applications, requiring digital signatures or disabling macros entirely for documents from untrusted sources

**Email Security**:
- Implement email security gateways with sandbox analysis for attachments
- Deploy multi-factor authentication (MFA) for email accounts to prevent credential-based compromise
- Monitor for unusual SMTP authentication patterns, particularly AUTH LOGIN from internal systems

**Policy and Training**:
- Conduct security awareness training emphasizing risks of downloading and opening files from unknown sources
- Implement principle of least privilege to limit damage from compromised accounts
- Establish incident response procedures with defined escalation paths and forensic evidence preservation protocols

### 4.4 Lessons Learned

This incident demonstrates the critical importance of network monitoring and the value of full packet capture for forensic investigation. The multi-layered attack approach, using legitimate-seeming domains and encrypted communications, highlights the sophistication of modern malware campaigns. Organizations must adopt defense-in-depth strategies combining network security, endpoint protection, user training, and robust incident response capabilities to effectively defend against such threats.

---

## References

[1] Wireshark Foundation, "Wireshark User's Guide," Available: https://www.wireshark.org/docs/wsug_html_chunked/ [Accessed: Nov. 2, 2025]

[2] MITRE ATT&CK, "Cobalt Strike, Software S0154," Available: https://attack.mitre.org/software/S0154/ [Accessed: Nov. 2, 2025]

[3] MITRE ATT&CK, "T1071.001 - Application Layer Protocol: Web Protocols," Available: https://attack.mitre.org/techniques/T1071/001/ [Accessed: Nov. 2, 2025]

[4] SANS Institute, "Network Forensics: Tracking Hackers Through Cyberspace," Available: https://www.sans.org/reading-room/whitepapers/forensics/network-forensics-tracking-hackers-cyberspace-32923 [Accessed: Nov. 2, 2025]

[5] National Cyber Security Centre (NCSC), "Mitigating malware and ransomware attacks," Available: https://www.ncsc.gov.uk/guidance/mitigating-malware-and-ransomware-attacks [Accessed: Nov. 2, 2025]

---

## Appendix A: AI Usage Declaration

I used Claude AI (Anthropic) and ChatGPT to assist with the following aspects of this coursework:

1. **Understanding Concepts**: Clarification of Cobalt Strike characteristics, beaconing behavior, and typical C2 communication patterns
2. **Technical Assistance**: Guidance on TShark command-line syntax and Wireshark display filter formulation
3. **Analysis Methodology**: Recommendations on systematic approaches to PCAP analysis and timeline construction
4. **Report Structure**: Suggestions for organizing findings and improving clarity of technical explanations
5. **Grammar and Style**: Proofreading for grammatical correctness and academic writing style

All packet analysis, evidence collection, data interpretation, and conclusions presented in this report are based on my own examination of the provided PCAP file. The AI tools were used as learning aids and writing assistants, not to perform the actual forensic analysis or answer the coursework questions.

---

**End of Report**

