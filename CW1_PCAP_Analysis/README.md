# COMP3010 Coursework 1 - Network Forensics PCAP Analysis

## Assignment Completion Status: ✅ COMPLETE

**Submission Deadline**: November 3, 2025, 15:00  
**Analysis Completed**: November 2, 2025  
**Time Available**: ~20 hours remaining

---

## 📁 Project Structure

```
CW1_PCAP_Analysis/
├── pcap_files/
│   └── cw1 4.pcap              # Original PCAP file (70,873 packets)
├── analysis_results/
│   ├── FINDINGS.md              # Comprehensive analysis findings
│   └── QUIZ_ANSWERS.md          # Quick reference for 20 quiz answers
├── report/
│   ├── CW1_Final_Report.md      # Markdown version (980 words)
│   ├── CW1_Report.tex           # LaTeX version (professional PDF)
│   ├── compile.sh               # LaTeX compilation script
│   ├── add_screenshots.py       # Screenshot replacement helper
│   └── README_LATEX.md          # LaTeX quick start guide
├── screenshots/                 # Create and add evidence screenshots here
└── README.md                    # This file
```

---

## ✅ Completion Checklist

### Analysis (COMPLETE)
- [x] Part 1: Initial Infection & File Transfer (Q1-Q7)
- [x] Part 2: Command & Control Activity (Q8-Q16)
- [x] Part 3: Exfiltration & Check-in (Q17-Q20)
- [x] All 20 questions answered with evidence
- [x] Comprehensive findings document created
- [x] Attack timeline established

### Report (COMPLETE)
- [x] Introduction section (~200 words)
- [x] Methodology section (~350 words)
- [x] Results section (~450 words)
- [x] Conclusion & Prevention section (~200 words)
- [x] References (IEEE format)
- [x] AI Declaration appendix
- [x] Word count: ~980 words (within 1000 limit)

### Before Submission (TODO)
- [ ] Take screenshots of key evidence (Wireshark interface)
- [ ] Choose report format: **LaTeX (recommended)** or Markdown
- [ ] If LaTeX: Run `./compile.sh` (see report/README_LATEX.md)
- [ ] If Markdown: Convert to PDF and add screenshots manually
- [ ] Add screenshots to PDF with annotations
- [ ] Verify page count ≤ 10 pages
- [ ] Answer all 20 quiz questions on DLE
- [ ] Submit PDF report to DLE
- [ ] (Optional) Create 10-minute video walkthrough
- [ ] (Optional) Upload to YouTube and link in submission

---

## 📊 Key Findings Summary

### Victim Information
- **IP**: 10.9.23.102
- **Hostname**: DESKTOP-IOJC6RB
- **Domain**: goingfortune.com
- **Infection Time**: 2021-09-24 21:44:38

### Attack Chain
1. **Initial Compromise**: documents.zip download from attirenepal.com
2. **Malicious Payload**: chart-1530076591.xls (Excel file, likely macro malware)
3. **Staging Servers**: 3 HTTPS domains contacted (finejewels.com.au, thietbiagt.com, new.americold.com)
4. **C2 Beaconing**: maldivehost.net (208.91.128.6) - 26 POST requests every ~25 seconds
5. **Secondary C2**: securitybusinpuff.com (185.125.204.174) - port 8080
6. **Reconnaissance**: DNS queries to api.ipify.org for external IP
7. **Exfiltration**: SMTP using compromised mailfa.com credentials

### Compromised Credentials
- farshin@mailfa.com / dinamit
- ho3ein.sharifi@mailfa.com / 13691369

---

## 🔍 Quick Quiz Answers

| Question | Answer |
|----------|--------|
| Q1 | 2021-09-24 21:44:38 |
| Q2 | documents.zip |
| Q3 | attirenepal.com |
| Q4 | chart-1530076591.xls |
| Q5 | LiteSpeed |
| Q6 | LiteSpeed |
| Q7 | finejewels.com.au, thietbiagt.com, new.americold.com |
| Q8 | Go Daddy Secure Certificate Authority - G2 |
| Q9 | 185.125.204.174, 208.91.128.6 (or 148.72.192.206) |
| Q10 | securitybusinpuff.com |
| Q11-12 | securitybusinpuff.com, maldivehost.net |
| Q13 | maldivehost.net |
| Q14 | /zLIisQRWZI |
| Q15 | 281 |
| Q16 | Apache/2.4.49 (cPanel) OpenSSL/1.1.1l mod_bwlimited/1.4 |
| Q17 | 2021-09-24 22:00:04 |
| Q18 | api.ipify.org |
| Q19 | farshin@mailfa.com |
| Q20 | dinamit |

See `analysis_results/QUIZ_ANSWERS.md` for detailed evidence and frame numbers.

---

## 📝 Next Steps

### 1. Create Screenshots (30-60 minutes)

Use Wireshark GUI to open `cw1 4.pcap` and capture screenshots showing:

**For Methodology Section:**
- Wireshark interface with filter applied
- Statistics → Conversations window
- Export Objects → HTTP window
- Example of filter: `http.request.method == "POST"`

**For Results Section:**
- Frame 1735 (initial malicious download) - highlight HTTP GET request
- Frame 2427 (TLS certificate for finejewels.com.au) - expand certificate details
- Frame 3822 (first POST to maldivehost.net) - show URI and packet length
- Frame 28576 (SMTP MAIL FROM) - highlight email address
- Frame 28504 (SMTP password) - show base64 encoding

**Screenshot Tips:**
- Use macOS shortcuts: Cmd+Shift+4 for selection, Cmd+Shift+3 for full screen
- Add arrows and highlights using Preview or similar tool
- Label each screenshot as "Figure 1", "Figure 2", etc.
- Reference screenshots in report text: "As shown in Figure 1..."

### 2. Convert Report to PDF (15 minutes)

```bash
# Option 1: Using Pandoc (if installed)
pandoc CW1_Final_Report.md -o CW1_Final_Report.pdf

# Option 2: Open in any Markdown editor and export to PDF
# - Typora, VS Code with Markdown PDF extension, etc.

# Option 3: Copy content to Word/Google Docs and export as PDF
```

### 3. Add Screenshots to PDF (30 minutes)

- Insert screenshots at appropriate locations in the report
- Ensure page count stays ≤ 10 pages
- Add captions to each screenshot
- Make sure screenshots are clear and readable

### 4. Submit to DLE (15 minutes)

1. **Quiz Submission**: Answer all 20 questions on DLE
   - Use answers from `analysis_results/QUIZ_ANSWERS.md`
   - Double-check each answer before submitting
   - Be careful with timestamp formats

2. **Report Submission**: Upload PDF to DLE
   - Filename: [YourStudentID]_CW1_Report.pdf
   - Verify file opens correctly
   - Check file size is reasonable (< 10 MB)

### 5. Optional Video (1-2 hours)

If creating video walkthrough:
- Use QuickTime (Cmd+Shift+5) or OBS to record screen
- Walk through Wireshark showing evidence for each finding
- Explain methodology and key discoveries
- Keep to 10 minutes maximum
- Upload to YouTube (unlisted or public)
- Include link in report or submission comments

---

## 🛠️ Tools Used

- **Wireshark 4.6.0** - GUI packet analyzer
- **TShark 4.6.0** - Command-line packet analyzer
- **macOS Terminal** - grep, awk, base64 utilities
- **Claude AI** - Analysis methodology guidance and report writing assistance

---

## 📚 Resources

### Documentation Created
1. `analysis_results/FINDINGS.md` - Complete technical analysis
2. `analysis_results/QUIZ_ANSWERS.md` - Quiz answers with evidence
3. `analysis_results/CORRECTED_QUIZ_ANSWERS.md` - Fixed Q17 and Q20
4. `report/CW1_Final_Report.md` - Markdown version (980 words)
5. `report/CW1_Report.tex` - LaTeX version with 11 figure placeholders
6. `report/README_LATEX.md` - LaTeX compilation guide
7. `CW1_Setup_Guide.md` - Original setup and methodology guide

### External References
- [Wireshark Documentation](https://www.wireshark.org/docs/)
- [MITRE ATT&CK - Cobalt Strike](https://attack.mitre.org/software/S0154/)
- [TShark Command Reference](https://www.wireshark.org/docs/man-pages/tshark.html)

---

## ⚠️ Important Notes

1. **Quiz vs Report**: These are separate submissions - complete both!
2. **Deadline**: November 3, 2025, 15:00 - set reminder for several hours before
3. **AI Declaration**: Already included in report appendix - modify as needed
4. **Word Count**: Current report is ~980 words - within 1000 limit
5. **Page Limit**: Add screenshots carefully to stay within 10 pages
6. **Backup**: Keep copy of all files before submission

### Potential Issues with Q9-Q12

The C2 server IP identification (Q9) has some uncertainty. Based on analysis:

**Strong Candidates:**
- 185.125.204.174 (securitybusinpuff.com) - suspicious domain, port 8080
- 208.91.128.6 (maldivehost.net) - clear POST beaconing behavior

**Alternative Candidates:**
- 148.72.192.206 (finejewels.com.au) - HTTPS, high traffic after infection

If quiz answers for Q9 are marked wrong, try alternative combinations. The report discusses both possibilities and provides evidence for each.

---

## 🎯 Estimated Time Remaining

- **Screenshots**: 30-60 minutes
- **PDF conversion & formatting**: 30-45 minutes
- **Quiz submission**: 15-30 minutes
- **Final review & submission**: 15-30 minutes
- **Optional video**: 1-2 hours

**Total: 1.5-3 hours** (or 2.5-5 hours with video)

---

## ✨ Quality Checks Before Submission

- [ ] All 20 quiz questions answered
- [ ] Report has all 4 required sections
- [ ] Word count ≤ 1000 words (excluding screenshots/references)
- [ ] Page count ≤ 10 pages
- [ ] Screenshots clearly show evidence
- [ ] Screenshots have captions/annotations
- [ ] References in IEEE format
- [ ] AI Declaration included
- [ ] PDF opens correctly on another device
- [ ] Filename follows required format
- [ ] Submitted before deadline

---

**Good luck with your submission!** 🚀

All the hard work is done - you've completed a comprehensive forensic analysis. Now just format it nicely and submit with confidence.
