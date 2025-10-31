# Quick Start Guide - CW1 PCAP Analysis

## First Time Setup (Do This Once)

### 1. Install Wireshark
```bash
# You need to run this yourself (it will ask for your password)
brew install --cask wireshark

# Verify installation
wireshark --version
tshark --version
```

### 2. Get Your PCAP File
- Log into DLE (Digital Learning Environment)
- Go to COMP3010 module page
- Download the PCAP file for CW1
- Save it to: `~/DMR/CW1_PCAP_Analysis/pcap_files/`

### 3. Update the Helper Script
```bash
cd ~/DMR/CW1_PCAP_Analysis
nano analysis_helpers.sh
# Change line 12 to point to your actual PCAP filename:
# PCAP_FILE="./pcap_files/YOUR_ACTUAL_FILENAME.pcap"
```

---

## Daily Workflow

### Starting Analysis
```bash
cd ~/DMR/CW1_PCAP_Analysis

# Option 1: Open with Wireshark GUI
wireshark pcap_files/your_file.pcap

# Option 2: Use the helper script
./analysis_helpers.sh menu

# Option 3: Quick command-line check
tshark -r pcap_files/your_file.pcap -q -z io,stat,0
```

### Taking Screenshots
- **Cmd + Shift + 4** → Select area to capture
- **Cmd + Shift + 4** then **Space** → Capture specific window
- Save to: `screenshots/` folders (methodology, results, evidence)

### Tracking Your Answers
```bash
# Open your answers tracker
open -a TextEdit answers_tracker.md

# Or use any editor you prefer
nano answers_tracker.md
```

---

## Essential Wireshark Filters (Cheat Sheet)

### Finding Initial Infection
```
http.request.method == "GET"
http.request.uri contains ".zip"
http.request.uri contains ".exe"
```

### Finding Domains in HTTPS
```
tls.handshake.extensions_server_name
```

### Time-Based Filtering
```
frame.time >= "2024-08-15 16:45:11" && frame.time <= "2024-08-15 16:45:30"
```

### Finding C2 Traffic
```
http.request.method == "POST"
tls && ip.dst == [suspicious_IP]
```

### Finding Email/SMTP
```
smtp
smtp.req.command == "MAIL FROM"
```

### Finding DNS Queries
```
dns.qry.name contains "ip"
dns.qry.name contains "checkip"
```

---

## Key Wireshark Features

### Export HTTP Files
1. File → Export Objects → HTTP
2. Save the files you need
3. Extract/analyze them

### Follow Conversations
1. Right-click on a packet
2. Follow → TCP Stream / HTTP Stream / TLS Stream
3. See the complete conversation

### View Statistics
- Statistics → Conversations (see all IP conversations)
- Statistics → Protocol Hierarchy (protocol distribution)
- Statistics → HTTP → Requests (all HTTP requests)

### Find Packets
- Edit → Find Packet (Cmd+F)
- Can search by display filter, hex, string

---

## Analysis Checklist

### Part 1: Initial Infection (Q1-7)
- [ ] Found first malicious HTTP request (Q1)
- [ ] Identified downloaded file (Q2)
- [ ] Found hosting domain (Q3)
- [ ] Extracted and examined archive contents (Q4)
- [ ] Identified web server software (Q5)
- [ ] Found web server version (Q6)
- [ ] Identified 3 additional domains (Q7)
- [ ] Screenshots taken for all

### Part 2: C2 Activity (Q8-16)
- [ ] Found Certificate Authority (Q8)
- [ ] Identified both C2 IPs (Q9)
- [ ] Found Host header for C2 #1 (Q10)
- [ ] Found domain for C2 #1 (Q11)
- [ ] Found domain for C2 #2 (Q12)
- [ ] Identified post-infection domain (Q13)
- [ ] Extracted first 11 chars of data (Q14)
- [ ] Found packet length (Q15)
- [ ] Found Server header (Q16)
- [ ] Screenshots taken for all

### Part 3: Exfiltration (Q17-20)
- [ ] Found IP check DNS query time (Q17)
- [ ] Identified IP check domain (Q18)
- [ ] Found SMTP MAIL FROM email (Q19)
- [ ] Extracted password from SMTP (Q20)
- [ ] Screenshots taken for all

### Report Writing
- [ ] Introduction section written (~150-200 words)
- [ ] Methodology section written (~300-350 words)
- [ ] Results section written (~400-450 words)
- [ ] Conclusion section written (~150-200 words)
- [ ] All screenshots included and referenced
- [ ] References in IEEE format
- [ ] Word count ≤ 1000 words
- [ ] Page count ≤ 10 pages

### Final Submission
- [ ] All quiz questions answered on DLE
- [ ] Report exported to PDF
- [ ] AI Declaration completed and attached
- [ ] Optional: GitHub repo created
- [ ] Optional: Video walkthrough recorded
- [ ] Submitted before Nov 3, 2025 15:00

---

## Common Issues & Solutions

### "tshark: command not found"
```bash
# tshark comes with Wireshark, make sure it's in your PATH
export PATH="/Applications/Wireshark.app/Contents/MacOS:$PATH"

# Or use the full path
/Applications/Wireshark.app/Contents/MacOS/tshark --version
```

### "Cannot open file: Permission denied"
```bash
# Make sure file permissions are correct
chmod 644 pcap_files/*.pcap
```

### "Too many packets, Wireshark is slow"
```bash
# Use display filters to reduce view
# Or use tshark for specific queries instead of GUI
```

### Can't find specific packet
```bash
# Use Find (Cmd+F) or display filters
# Check if you're looking at the right time range
# Verify your filter syntax
```

---

## Time Management

### Week 1 (Install & Learn)
- Install tools
- Get PCAP file
- Learn Wireshark basics
- Start Part 1 questions

### Week 2 (Analysis)
- Complete all quiz questions
- Take comprehensive screenshots
- Organize your evidence
- Start report outline

### Week 3 (Report & Submit)
- Write complete report
- Optional: Record video
- Final review
- Submit everything

**Deadline: November 3, 2025 at 15:00**

---

## Getting Help

### Module Support
- **Module Leader:** Dr Ji-Jian Chin
- **DLE Forum:** Post questions (don't share answers!)
- **Office Hours:** Check DLE for schedule

### Learning Resources
- **Wireshark Docs:** https://www.wireshark.org/docs/
- **Wireshark Wiki:** https://wiki.wireshark.org/
- **Sample PCAPs:** https://wiki.wireshark.org/SampleCaptures

### AI Assistance (Remember to Declare!)
You CAN use AI for:
- Understanding concepts
- Learning filter syntax
- Improving your writing
- Debugging commands

You CANNOT use AI for:
- Doing the analysis for you
- Getting direct answers
- Writing your report wholesale

---

## Tips for Success

1. **Start Early** - PCAP analysis has a learning curve
2. **Document Everything** - Take screenshots as you go
3. **Organize Files** - Use the folder structure provided
4. **Save Frequently** - Keep versions of your work
5. **Test Your Filters** - Verify they show what you expect
6. **Explain Your Screenshots** - Don't just paste them
7. **Check Your Work** - Verify answers make sense
8. **Watch the Video** - Optional but can boost marks
9. **Read the Rubric** - Know how you'll be graded
10. **Don't Plagiarize** - Do your own analysis

---

Good luck! 🎯

