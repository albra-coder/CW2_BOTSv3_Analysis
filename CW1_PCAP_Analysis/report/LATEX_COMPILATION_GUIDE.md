# LaTeX Report Compilation Guide

## 📄 Files Created

- **`CW1_Report.tex`**: Main LaTeX source file with 11 screenshot placeholders

## 🖼️ Screenshot Placeholders

The report includes **11 placeholder boxes** for screenshots. Here's what you need to capture:

### Screenshot 1: Wireshark Main Interface
**Location**: Figure 1 (Page 2)
**What to capture**: 
- Open `cw1 4.pcap` in Wireshark GUI
- Show the main interface with packet list
- Capture: Cmd+Shift+4, select the entire Wireshark window

**Save as**: `screenshot1_wireshark_interface.png`

---

### Screenshot 2: IPv4 Conversations
**Location**: Figure 2 (Page 3)
**What to capture**:
- Statistics → Conversations
- Click "IPv4" tab
- Show victim IP (10.9.23.102) and top connections
- Sort by Bytes (descending) to show top traffic

**Save as**: `screenshot2_conversations.png`

---

### Screenshot 3: Display Filter - POST Requests
**Location**: Figure 3 (Page 4)
**What to capture**:
- Apply filter: `http.request.method == "POST"`
- Show the filter bar and filtered results
- Highlight some POST requests to maldivehost.net

**Save as**: `screenshot3_filter_post.png`

---

### Screenshot 4: Export HTTP Objects
**Location**: Figure 4 (Page 4)
**What to capture**:
- File → Export Objects → HTTP
- Show the list with documents.zip visible
- Highlight documents.zip row

**Save as**: `screenshot4_export_objects.png`

---

### Screenshot 5: Initial Malicious Download
**Location**: Figure 5 (Page 5)
**What to capture**:
- Navigate to frame 1735
- Show the HTTP GET request details
- Expand HTTP header to show:
  - Request URI: `/incidunt-consequatur/documents.zip`
  - Host: `attirenepal.com`
  - Timestamp: 21:44:38

**Save as**: `screenshot5_initial_download.png`

---

### Screenshot 6: TLS Server Name Indication
**Location**: Figure 6 (Page 6)
**What to capture**:
- Navigate to frame 2427
- Expand: Transport Layer Security → Handshake Protocol: Client Hello
- Expand: Extension: server_name
- Show "Server Name: finejewels.com.au"

**Save as**: `screenshot6_tls_sni.png`

---

### Screenshot 7: TLS Certificate Details
**Location**: Figure 7 (Page 6)
**What to capture**:
- Find the Server Certificate packet for finejewels.com.au (around frame 2436)
- Expand: Transport Layer Security → Handshake Protocol: Certificate
- Expand: Certificates → Certificate
- Show Issuer field with "Go Daddy Secure Certificate Authority - G2"

**Save as**: `screenshot7_certificate.png`

---

### Screenshot 8: C2 Beaconing
**Location**: Figure 8 (Page 7)
**What to capture**:
- Navigate to frame 3822
- Show the first POST request to maldivehost.net
- Expand HTTP header to show:
  - Request URI: `/zLIisQRWZI9/OQsaDixzHTgtfjMcGypGenpldWF5eWV9f3k=`
  - Host: maldivehost.net
  - Frame Length: 281

**Save as**: `screenshot8_c2_beacon.png`

---

### Screenshot 9: DNS Query to api.ipify.org
**Location**: Figure 9 (Page 7)
**What to capture**:
- Filter: `dns.qry.name == "api.ipify.org"`
- Show the first DNS query
- Display timestamp (22:00:04 local, 17:00:04 UTC)

**Save as**: `screenshot9_dns_ipify.png`

---

### Screenshot 10: SMTP MAIL FROM
**Location**: Figure 10 (Page 8)
**What to capture**:
- Navigate to frame 28576
- Show SMTP MAIL FROM command
- Expand SMTP to show: `MAIL FROM:<farshin@mailfa.com>`

**Save as**: `screenshot10_smtp_mailfrom.png`

---

### Screenshot 11: SMTP Authentication
**Location**: Figure 11 (Page 8)
**What to capture**:
- Navigate to frame 28763
- Show SMTP AUTH LOGIN response
- Expand to show base64 password: `MTM2OTEzNjk=`
- You can add annotation showing decoded: "13691369"

**Save as**: `screenshot11_smtp_auth.png`

---

## 📝 How to Add Screenshots to LaTeX

### Option 1: Replace Placeholder Boxes (Recommended)

1. Save all screenshots with exact names listed above
2. Place screenshots in the same directory as `CW1_Report.tex`
3. Replace each placeholder section with actual image:

**Find this**:
```latex
\fbox{\parbox{0.9\textwidth}{\centering \vspace{3cm} \textbf{[SCREENSHOT 1]}\\Wireshark Main Interface\\Showing PCAP file loaded\\\vspace{3cm}}}
```

**Replace with**:
```latex
\includegraphics[width=0.9\textwidth]{screenshot1_wireshark_interface.png}
```

Do this for all 11 screenshots.

### Option 2: Keep Placeholders for Draft

- Compile as-is to see layout with placeholder boxes
- Useful for checking page count and formatting
- Add real screenshots later

---

## 🔧 Compiling the LaTeX Document

### Method 1: Using Command Line (if you have LaTeX installed)

```bash
cd /Users/macbookpro/DMR/CW1_PCAP_Analysis/report

# Compile (run twice for references)
pdflatex CW1_Report.tex
pdflatex CW1_Report.tex

# Open the PDF
open CW1_Report.pdf
```

### Method 2: Using Overleaf (Online, No Installation)

1. Go to https://www.overleaf.com
2. Create free account
3. New Project → Upload Project
4. Upload `CW1_Report.tex`
5. Upload all screenshot images
6. Click "Recompile"
7. Download PDF

### Method 3: Using VS Code with LaTeX Workshop

1. Install extension: "LaTeX Workshop"
2. Open `CW1_Report.tex`
3. Click "Build LaTeX project" button
4. PDF will auto-generate

### Method 4: Using TeXShop (macOS)

1. Install MacTeX: https://tug.org/mactex/
2. Open `CW1_Report.tex` in TeXShop
3. Click "Typeset" button
4. PDF will appear

---

## 📦 Installing LaTeX (if needed)

### macOS:
```bash
# Install MacTeX (large, ~4 GB)
brew install --cask mactex

# Or install BasicTeX (smaller, ~100 MB)
brew install --cask basictex

# After BasicTeX, install required packages:
sudo tlmgr install collection-latex
sudo tlmgr install collection-latexrecommended
```

### Alternative: Use Overleaf (No Installation Required)
- Go to https://www.overleaf.com
- Free online LaTeX editor
- No software installation needed

---

## ✅ Before Final Compilation

1. **Add Your Name and Student ID**: 
   - Line 32: Replace `[Your Name]`
   - Line 33: Replace `[Your Student ID]`

2. **Take All 11 Screenshots**: Follow the guide above

3. **Replace Placeholder Boxes**: With actual `\includegraphics` commands

4. **Check Page Count**: Should be ≤ 10 pages
   - If over 10 pages, reduce screenshot sizes or adjust margins

5. **Verify Word Count**: Run this command:
   ```bash
   detex CW1_Report.tex | wc -w
   ```
   Should be around 980-1000 words (excluding screenshots/references)

---

## 📊 Document Structure

The LaTeX report includes:

- ✅ Title page with your details
- ✅ Abstract
- ✅ Table of Contents
- ✅ 4 Main Sections (Introduction, Methodology, Results, Conclusion)
- ✅ 11 Figure placeholders with captions
- ✅ IEEE-style bibliography (5 references)
- ✅ AI Usage Declaration appendix
- ✅ Professional formatting with headers/footers

---

## 🎨 Customization Options

### Adjust Margins (if page count is over 10):
```latex
% Line 6: Change from 1in to 0.8in
\usepackage[margin=0.8in]{geometry}
```

### Change Font Size:
```latex
% Line 1: Change from 11pt to 10pt
\documentclass[10pt,a4paper]{article}
```

### Adjust Screenshot Sizes:
```latex
% Change width from 0.9 to 0.8
\includegraphics[width=0.8\textwidth]{screenshot.png}
```

---

## 🐛 Common Compilation Errors

### Error: "File not found"
**Solution**: Make sure screenshot files are in the same directory as the .tex file

### Error: "Undefined control sequence"
**Solution**: Install missing packages:
```bash
sudo tlmgr install <package-name>
```

### Error: "Emergency stop"
**Solution**: Check for syntax errors, missing braces `{}`, or unclosed environments

### PDF doesn't show images
**Solution**: 
1. Make sure images are PNG or JPG
2. Run pdflatex twice (first run generates references)
3. Check image paths are correct

---

## 📤 Final Submission

1. **Compile final PDF**: `CW1_Report.pdf`
2. **Verify**:
   - ✅ Page count ≤ 10 pages
   - ✅ All 11 screenshots visible and clear
   - ✅ Your name and student ID filled in
   - ✅ All sections complete
   - ✅ References and AI declaration included
3. **Submit to DLE**: Upload `CW1_Report.pdf`

---

## 📞 Need Help?

If compilation fails:
1. Use Overleaf (easiest, web-based)
2. Or send me the error message
3. Or use the markdown version and convert to PDF via Word/Google Docs

**The LaTeX file is ready - just need to add screenshots and compile!**

