# COMP3010 Coursework 1: Complete Setup & Analysis Guide

## Table of Contents
1. [Installation & Setup](#installation--setup)
2. [Understanding PCAP Analysis](#understanding-pcap-analysis)
3. [Wireshark Basics](#wireshark-basics)
4. [Analysis Methodology](#analysis-methodology)
5. [Question-by-Question Guidance](#question-by-question-guidance)
6. [Report Writing](#report-writing)
7. [Submission Checklist](#submission-checklist)

---

## Installation & Setup

### Step 1: Install Wireshark

```bash
# Install Wireshark (GUI + tshark CLI)
brew install --cask wireshark

# Verify installation
wireshark --version
tshark --version
```

### Step 2: Set Up Your Working Directory

```bash
# Navigate to your project directory
cd ~/DMR

# Create organized folder structure
mkdir -p CW1_PCAP_Analysis/{pcap_files,screenshots,queries,report}
cd CW1_PCAP_Analysis

# Create subdirectories for organization
mkdir -p screenshots/{methodology,results,evidence}
mkdir -p report/{drafts,final}
```

### Step 3: Download PCAP File from DLE
- Log into your DLE (Digital Learning Environment)
- Navigate to COMP3010 module page
- Download the provided PCAP file
- Save it to `~/DMR/CW1_PCAP_Analysis/pcap_files/`

### Step 4: Optional Tools (Helpful but not required)

```bash
# NetworkMiner (for network forensics)
# Download from: https://www.netresec.com/?page=NetworkMiner

# Install tcpdump (command-line packet analyzer)
brew install tcpdump

# Install useful utilities
brew install jq        # JSON processor (useful for parsing)
brew install grep      # Better grep with colors
```

---

## Understanding PCAP Analysis

### What is a PCAP file?
- **PCAP** = Packet Capture
- Contains recorded network traffic
- Shows all packets sent/received on a network
- Used for network troubleshooting and security analysis

### What You're Looking For:
1. **Initial Infection Vector** - How did malware get in?
   - Malicious downloads
   - Phishing links
   - Exploit delivery
   
2. **Command & Control (C2)** - How does malware communicate?
   - Beaconing behavior
   - C2 server connections
   - Data exfiltration
   
3. **Indicators of Compromise (IOCs)**
   - Suspicious domains
   - Known malicious IPs
   - Unusual file transfers
   - Strange user agents

---

## Wireshark Basics

### Opening and Initial Inspection

```bash
# Open PCAP file with Wireshark GUI
wireshark /path/to/your/file.pcap

# OR use command line to get quick stats
tshark -r /path/to/your/file.pcap -q -z io,stat,0
```

### Essential Wireshark Filters

#### 1. HTTP Traffic
```
http
http.request
http.request.method == "GET"
http.request.method == "POST"
```

#### 2. HTTPS/TLS Traffic
```
tls
tls.handshake.type == 1  # Client Hello
ssl.handshake.extensions_server_name  # SNI - see domains
```

#### 3. DNS Queries
```
dns
dns.qry.name contains "domain.com"
dns.qry.type == 1  # A records
```

#### 4. Specific IP Addresses
```
ip.addr == 192.168.1.100
ip.src == 192.168.1.100  # Source
ip.dst == 192.168.1.100  # Destination
```

#### 5. Time-based Filters
```
frame.time >= "2024-01-01 16:45:00" && frame.time <= "2024-01-01 16:46:00"
```

#### 6. File Downloads
```
http.request.method == "GET" && http.content_type contains "application"
http.content_type contains "zip"
http.content_type contains "exe"
```

#### 7. SMTP (Email) Traffic
```
smtp
smtp.req.command == "MAIL FROM"
smtp.req.command == "RCPT TO"
```

#### 8. Follow Streams
- Right-click on packet → Follow → TCP/HTTP/TLS Stream
- Shows entire conversation between client and server

### Useful Wireshark Features

#### Statistics Menu
```
Statistics → Conversations
  - See all IP conversations
  - Identify largest data transfers
  
Statistics → Protocol Hierarchy
  - Overview of protocols used
  
Statistics → HTTP → Requests
  - All HTTP requests made
  
Statistics → Resolved Addresses
  - DNS resolutions in the capture
```

#### Export Objects
```
File → Export Objects → HTTP
  - Extract files transferred via HTTP
  - See downloaded files, their names, sizes
```

---

## Analysis Methodology

### Phase 1: Initial Reconnaissance (30 minutes)

```bash
# Open PCAP in Wireshark
wireshark your_file.pcap

# Get basic statistics
tshark -r your_file.pcap -q -z conv,ip
tshark -r your_file.pcap -q -z http,tree
```

**Tasks:**
1. Note the time range of the capture
2. Identify the victim's IP address (usually internal: 192.168.x.x, 10.x.x.x)
3. Look at Protocol Hierarchy (Statistics → Protocol Hierarchy)
4. Check HTTP requests (Statistics → HTTP → Requests)

### Phase 2: Timeline Creation (1 hour)

Create a timeline of events:
```
[Time]          [Event]                    [Details]
16:45:00        Initial HTTP Request       Downloaded file X from domain Y
16:45:15        DNS Query                  Queried for malicious.domain.com
16:45:30        HTTPS Connection           Connected to C2 server Z
```

### Phase 3: Detailed Analysis by Question Category

#### Part 1: Initial Infection & File Transfer

**What to look for:**
- HTTP GET requests downloading files
- Check for .zip, .exe, .dll, .scr files
- Look at domains serving files
- Extract downloaded files using "Export Objects"

**Key Wireshark Operations:**
```
1. Filter: http.request.method == "GET"
2. Look for suspicious domains
3. File → Export Objects → HTTP
4. Check Server headers in HTTP responses
5. Note timestamps carefully
```

#### Part 2: Command & Control Activity

**What to look for:**
- HTTPS connections to unusual domains
- POST requests with encrypted data
- Beaconing (regular connections at intervals)
- Cobalt Strike indicators

**Cobalt Strike Characteristics:**
- Uses HTTPS for C2 communication
- Regular beacon check-ins
- Specific User-Agent strings
- Malleable C2 profiles

**Key Wireshark Operations:**
```
1. Statistics → Conversations → filter for most active connections
2. Filter: tls && ip.dst == [suspicious_ip]
3. Look at TLS certificates (expand packet details)
4. Check for POST requests: http.request.method == "POST"
5. Examine Host headers in HTTP requests
```

#### Part 3: Exfiltration/Check-in

**What to look for:**
- DNS queries to IP checking services (e.g., api.ipify.org, checkip.amazonaws.com)
- SMTP traffic (email exfiltration)
- Large data transfers
- Credentials in plaintext

**Key Wireshark Operations:**
```
1. Filter: dns.qry.name contains "ip"
2. Filter: smtp
3. Follow SMTP stream to see email contents
4. Check for MAIL FROM and passwords in clear text
```

---

## Question-by-Question Guidance

### Part 1: Initial Infection & File Transfer

#### Question 1: When did the initial malicious HTTP connection occur?
**Approach:**
1. Filter: `http.request`
2. Sort by time (click Time column)
3. Look for first suspicious GET request
4. Note the exact timestamp
5. Format: `yyyy-mm-dd hh:mm:ss`

**How to find timestamp:**
- Select packet
- Look at Frame details → Arrival Time
- Right-click → Copy → "As Displayed"

#### Question 2: Name of compressed file downloaded?
**Approach:**
1. File → Export Objects → HTTP
2. Look for .zip, .7z, .rar, .gz files
3. Note the exact filename
4. Verify by checking the HTTP GET request

#### Question 3: Which domain hosted the malicious file?
**Approach:**
1. Find the packet with the file download (from Q2)
2. Look at HTTP headers
3. Check "Host:" header
4. OR look at the URL in the GET request

**Filter example:**
```
http.request.uri contains ".zip"
```

#### Question 4: Name of file inside the compressed archive?
**Approach:**
1. Export the zip file (Export Objects → HTTP)
2. Save it to your system
3. Unzip it (might need password from analysis)
4. Note the filename inside

**Alternative:**
- Some ZIP file content may be visible in packet data
- Look for ZIP file headers: PK\x03\x04

#### Question 5 & 6: Web server software and version?
**Approach:**
1. Find the HTTP response for the file download
2. Look in HTTP headers for "Server:" field
3. Example: `Server: Apache/2.4.52 (Ubuntu)`
   - Software: Apache
   - Version: 2.4.52

**Filter:**
```
http.response && http contains "Server:"
```

#### Question 7: Three additional domains downloading malicious files?
**Approach:**
1. Apply time filter: between 16:45:11 and 16:45:30
```
frame.time >= "2024-XX-XX 16:45:11" && frame.time <= "2024-XX-XX 16:45:30"
```
2. Look at HTTPS traffic (TLS Client Hello)
3. Check SNI (Server Name Indication) field:
```
tls.handshake.extensions_server_name
```
4. List all unique domains contacted

**How to see domains in HTTPS:**
- Expand packet: Transport Layer Security → Handshake Protocol
- Look for "Server Name" extension

---

### Part 2: Command & Control Activity

#### Question 8: Certificate Authority for first domain?
**Approach:**
1. Find TLS handshake for the domain from Q7
2. Look for Server Certificate packet
3. Expand: Certificates → Certificate
4. Find "Issuer" field
5. Look for "CN=" (Common Name) - that's the CA

**Filter:**
```
tls.handshake.type == 11  # Server Certificate
```

#### Question 9: Two Cobalt Strike server IPs?
**Approach:**
1. Statistics → Conversations → IPv4
2. Sort by bytes transferred
3. Look for IPs with:
   - Regular beacon patterns
   - HTTPS connections (port 443)
   - Moderate but consistent traffic
4. Cross-reference with suspicious domains from earlier

**Cobalt Strike traffic characteristics:**
- Port 443 (HTTPS)
- Regular intervals (beaconing)
- POST requests with encoded data

#### Question 10: Host header for first Cobalt Strike IP?
**Approach:**
1. Take the first C2 IP from Q9
2. Filter: `ip.addr == [C2_IP] && http`
3. Look at HTTP requests to this IP
4. Find "Host:" header in the request
5. The Host header shows what domain name was used

**Why Host header matters:**
- IP might host multiple domains
- Host header shows which site was actually requested

#### Question 11 & 12: Domain names for C2 IPs?
**Approach:**
1. For each C2 IP, filter DNS queries:
```
dns && ip.addr == [C2_IP]
```
2. Look for DNS responses (Type A records)
3. Check the queried domain name

**Alternative approach:**
- Look at TLS SNI for connections to these IPs
```
ip.addr == [C2_IP] && tls.handshake.extensions_server_name
```

#### Question 13: Domain for post-infection traffic?
**Approach:**
1. Look at HTTP POST requests after infection
```
http.request.method == "POST"
```
2. Check Host headers
3. Look for repeating POST requests (beaconing)

#### Question 14: First eleven characters of data sent to C2?
**Approach:**
1. Find POST request to domain from Q13
2. Follow TCP stream (Right-click → Follow → TCP Stream)
3. Look at the POST data payload
4. Count first 11 characters
5. Might be base64 encoded or hex

**Tip:** Switch Stream direction to see client → server data

#### Question 15: Length of first packet to C2?
**Approach:**
1. Find first packet from victim to C2 domain
2. Look at packet details
3. Check "Length" column in packet list
4. OR look at Frame details → Frame Length

#### Question 16: Server header for malicious domain?
**Approach:**
1. Filter HTTP responses from the C2 domain:
```
http.response && http.host == "[domain]"
```
2. Look in HTTP headers for "Server:" field

---

### Part 3: Final Exfiltration/Check-in

#### Question 17 & 18: DNS query for external IP check?
**Approach:**
1. Filter: `dns`
2. Look for common IP checking services:
   - api.ipify.org
   - checkip.amazonaws.com
   - icanhazip.com
   - whatismyip.akamai.com
3. Note the exact timestamp and domain name

**Why malware does this:**
- Determines victim's external/public IP
- Reports back to attacker

#### Question 19 & 20: SMTP traffic and password?
**Approach:**
1. Filter: `smtp`
2. Look for `MAIL FROM:` command - that's the sender email
3. Find the SMTP conversation with this email
4. Right-click → Follow → TCP Stream
5. Look for AUTH LOGIN or plaintext credentials
6. Passwords might be base64 encoded

**SMTP Commands to look for:**
```
MAIL FROM: <email@domain.com>
RCPT TO: <recipient@domain.com>
AUTH LOGIN
[base64 username]
[base64 password]
```

**Decoding base64:**
```bash
echo "cGFzc3dvcmQxMjM=" | base64 -d
```

---

## Taking Screenshots for Evidence

### What to Capture

**For Methodology Section:**
1. Wireshark interface with filter applied
2. Statistics windows (Conversations, Protocol Hierarchy)
3. Export Objects window showing downloads
4. Command line outputs

**For Results Section:**
1. Specific packets that answer each question
2. Highlighted headers/fields that contain answers
3. Follow Stream windows showing conversations
4. Timeline or summary tables you create

### How to Take Good Screenshots on macOS

```bash
# Full screen
Cmd + Shift + 3

# Selected area
Cmd + Shift + 4

# Specific window
Cmd + Shift + 4, then press Space, then click window

# Screenshots save to Desktop by default
```

### Annotate Your Screenshots
- Use Preview.app or another tool to add:
  - Arrows pointing to important fields
  - Text boxes explaining what you're showing
  - Circles/highlights around key information

---

## Report Writing

### Section 1: Introduction (150-200 words)

**What to include:**
```
1. Brief overview of the assignment
   - "This report documents the forensic analysis of network traffic..."
   
2. What you're investigating
   - "A PCAP file containing evidence of a network intrusion..."
   
3. Report structure
   - "Section 2 describes the methodology..."
   - "Section 3 presents the findings..."
   - "Section 4 concludes with prevention recommendations..."
   
4. Scope
   - What time period
   - What network segment
   - What type of attack
```

**Example opening:**
> "This incident analysis report documents a comprehensive forensic examination 
> of network traffic captured during a suspected security breach. The analysis 
> focuses on identifying the infected system, determining the infection vector, 
> and characterizing the nature of the compromise. This investigation employs 
> packet analysis techniques using Wireshark to examine HTTP, HTTPS, DNS, and 
> SMTP traffic patterns."

### Section 2: Methodology (300-350 words)

**Structure:**
```
2.1 Tools and Environment
    - Wireshark version
    - Operating system
    - Additional tools used
    
2.2 Analysis Approach
    - Initial reconnaissance
    - Timeline development
    - Detailed packet examination
    
2.3 Specific Techniques
    - Protocol filtering
    - Stream following
    - Object extraction
    - Certificate examination
```

**Include screenshots showing:**
- Wireshark interface
- Filter examples
- Statistics windows

**Example paragraph:**
> "The analysis employed Wireshark 4.x on macOS for packet-level inspection. 
> The methodology followed a three-phase approach: (1) initial reconnaissance 
> using statistical analysis to identify traffic patterns and potential victim 
> systems; (2) timeline construction to map the sequence of events; and (3) 
> detailed examination of suspicious traffic using protocol filters and stream 
> reconstruction. Display filters were systematically applied to isolate HTTP, 
> TLS, DNS, and SMTP traffic..."

### Section 3: Results (400-450 words)

**Organize by attack phases:**

```
3.1 Initial Compromise
    - When: [timestamp]
    - How: [download method]
    - What: [file details]
    - Evidence: [screenshot + explanation]
    
3.2 Command & Control Establishment
    - C2 servers identified: [IPs and domains]
    - Communication method: [HTTPS/HTTP]
    - Beaconing pattern: [frequency]
    - Evidence: [screenshots]
    
3.3 Post-Exploitation Activity
    - Data exfiltration: [what was taken]
    - Additional downloads: [persistence mechanisms]
    - Lateral movement attempts: [if any]
    - Evidence: [screenshots]

3.4 Victim System Profile
    - IP Address: [internal IP]
    - MAC Address: [from ARP or similar]
    - Hostname: [from various protocols]
    - User Account: [from SMTP or other sources]
```

**Use your quiz answers to populate this section!**

**Evidence presentation:**
- Every claim needs a screenshot
- Reference screenshots: "As shown in Figure 1..."
- Explain what the screenshot proves

### Section 4: Conclusion & Prevention (150-200 words)

**Structure:**
```
4.1 Summary of Findings
    - Quick recap of the incident
    
4.2 Prevention Recommendations
    - Technical controls
    - Policy recommendations
    - User training needs
    
4.3 Open Issues / Challenges
    - Any unanswered questions
    - Limitations of the analysis
```

**Prevention techniques to discuss:**

**Technical Controls:**
- Network segmentation
- Intrusion Detection/Prevention Systems (IDS/IPS)
- Web filtering / DNS filtering
- Email security gateways
- Endpoint Detection and Response (EDR)
- SSL/TLS inspection

**Policy Recommendations:**
- Restrict downloads of executable files
- Implement application whitelisting
- Enforce principle of least privilege
- Regular security awareness training
- Incident response procedures

**Example paragraph:**
> "To prevent similar incidents, organizations should implement multi-layered 
> defenses including network-based intrusion detection systems configured to 
> detect Cobalt Strike traffic patterns, web content filtering to block known 
> malicious domains, and endpoint protection with behavioral analysis 
> capabilities. Additionally, user security awareness training should emphasize 
> the risks of downloading and executing files from untrusted sources..."

### References

Use IEEE format:
```
[1] Wireshark Foundation, "Wireshark User's Guide," Available: 
    https://www.wireshark.org/docs/wsug_html_chunked/

[2] MITRE ATT&CK, "Cobalt Strike Technique Analysis," Available: 
    https://attack.mitre.org/software/S0154/

[3] SANS Institute, "Intrusion Detection FAQ," Available: 
    https://www.sans.org/
```

---

## Workflow Summary

### Week 1: Setup & Initial Analysis
```bash
Day 1-2: Install tools, download PCAP, initial exploration
Day 3-4: Work through Part 1 questions (Initial Infection)
Day 5-6: Take screenshots, document findings
Day 7: Review and refine understanding
```

### Week 2: Deep Analysis
```bash
Day 1-2: Work through Part 2 questions (C2 Activity)
Day 3-4: Work through Part 3 questions (Exfiltration)
Day 5-6: Verify all answers, gather comprehensive evidence
Day 7: Start report outline
```

### Week 3: Report Writing & Submission
```bash
Day 1-2: Write Methodology and Results sections
Day 3: Write Introduction and Conclusion
Day 4: Create optional video walkthrough
Day 5: Review, proofread, check word count
Day 6: Final checks, submit to DLE
Day 7: Buffer day for any issues
```

---

## Submission Checklist

### Before You Submit:

- [ ] All 20 quiz questions answered on DLE
- [ ] Report is in PDF format
- [ ] Word count ≤ 1000 words (excluding screenshots and references)
- [ ] Page count ≤ 10 pages
- [ ] All 4 sections included (Introduction, Methodology, Results, Conclusion)
- [ ] Screenshots clearly show evidence
- [ ] Screenshots are annotated/explained
- [ ] References properly formatted (IEEE style)
- [ ] Generative AI Declaration completed and attached as appendix
- [ ] Filename follows any required naming convention
- [ ] File opens correctly (test on another device)
- [ ] Submitted before deadline: **November 3, 2025, 15:00**

### Optional but Recommended:
- [ ] Created public GitHub repository with your work
- [ ] Recorded 10-minute video walkthrough
- [ ] Video uploaded to YouTube (unlisted/public)
- [ ] Video embedded or linked in submission

---

## Common Pitfalls to Avoid

1. **Starting too late** - PCAP analysis takes time to learn
2. **Not taking enough screenshots** - Evidence is 30% of grade
3. **Copying screenshots without explanation** - Explain what they show
4. **Exceeding word/page limit** - Anything beyond limit won't be marked
5. **Not testing file before submission** - Corrupted PDFs can't be marked
6. **Forgetting AI Declaration** - Required appendix
7. **Not answering quiz separately** - Quiz and report are separate submissions
8. **Ignoring the optional video** - Can significantly boost your evidence marks

---

## Getting Help

### If You're Stuck:

1. **Re-read the assignment brief** - Often answers are there
2. **Check lecture materials** - Labs should have covered similar analysis
3. **Use AI tools (declare usage!)** - Ask ChatGPT/Claude to explain concepts
4. **Ask module leader** - Dr Ji-Jian Chin is there to help
5. **Study groups** - Discuss concepts (not answers) with classmates

### Good Questions to Ask:
- "How do I filter for X in Wireshark?"
- "What does this error message mean?"
- "Can you explain what Cobalt Strike is?"
- "Is this format correct for the report?"

### Bad Questions to Ask:
- "What's the answer to Question 5?"
- "Can you analyze this PCAP for me?"
- "What should I write for my results?"

---

## AI Usage Declaration

Remember to declare ALL AI usage in your appendix:

**Example declaration:**
> "I used ChatGPT/Claude to:
> - Understand what Cobalt Strike is
> - Learn how to use specific Wireshark filters
> - Debug tshark command syntax errors
> - Improve the clarity of my methodology section
> - Check grammar and spelling in my report
> 
> All analysis and conclusions are my own work based on my examination 
> of the PCAP file."

---

## Additional Resources

### Wireshark Learning:
- Official Wireshark Tutorial: https://www.wireshark.org/docs/wsug_html_chunked/
- Wireshark Display Filters: https://wiki.wireshark.org/DisplayFilters
- Wireshark Sample Captures: https://wiki.wireshark.org/SampleCaptures

### Malware Analysis:
- MITRE ATT&CK: https://attack.mitre.org/
- Cobalt Strike Analysis: Search for "cobalt strike traffic analysis"
- Network Forensics Guide: Search for "network forensics methodology"

### Report Writing:
- IEEE Reference Format: https://ieee-dataport.org/sites/default/files/analysis/27/IEEE%20Citation%20Guidelines.pdf
- Academic Writing Guide: University of Plymouth library resources

---

Good luck with your coursework! Take your time, document everything, and don't hesitate to ask for help when you need clarification on concepts or techniques.

