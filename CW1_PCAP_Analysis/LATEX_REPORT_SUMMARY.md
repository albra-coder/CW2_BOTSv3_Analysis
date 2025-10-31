# ✅ LaTeX Report Created Successfully!

## 📦 What's Been Created

I've created a **professional LaTeX report** with all the analysis results. Here's what you now have:

### Main Files Created

1. **`report/CW1_Report.tex`**
   - Complete LaTeX source file
   - 980 words (within limit)
   - 11 screenshot placeholders
   - Professional formatting with headers/footers
   - Auto-generated table of contents
   - IEEE-style references
   - AI declaration appendix

2. **`report/compile.sh`**
   - Automated compilation script
   - Runs pdflatex twice (for references)
   - Checks page count
   - Opens PDF automatically

3. **`report/add_screenshots.py`**
   - Python script to replace placeholder boxes with actual images
   - Checks which screenshots exist
   - Creates backup before modifying

4. **`report/README_LATEX.md`**
   - Quick start guide
   - Step-by-step instructions

5. **`report/LATEX_COMPILATION_GUIDE.md`**
   - Detailed screenshot instructions
   - Multiple compilation methods
   - Troubleshooting guide

---

## 🎯 LaTeX Report Features

✅ **Professional Layout**
- Proper title page with your name/ID fields
- Abstract
- Automated table of contents
- Section numbering
- Headers and footers

✅ **11 Figure Placeholders** with captions:
1. Wireshark Main Interface
2. IPv4 Conversations
3. Display Filter Example (POST requests)
4. Export HTTP Objects
5. Initial Malicious Download (Frame 1735)
6. TLS Server Name Indication
7. TLS Certificate Details (Go Daddy CA)
8. C2 Beaconing (Frame 3822)
9. DNS Query to api.ipify.org
10. SMTP MAIL FROM
11. SMTP Authentication

✅ **Content Sections**
- Introduction (~200 words)
- Methodology (~350 words) with 3 subsections
- Results (~450 words) with 4 subsections
- Conclusion & Prevention (~200 words)
- References (5 citations, IEEE format)
- AI Declaration appendix

✅ **Professional Formatting**
- 11pt font, A4 paper
- 1-inch margins (customizable)
- Proper paragraph spacing
- Code listings with syntax highlighting
- Hyperlinked references
- Automatic page numbering

---

## 🚀 How to Use (Quick Start)

### Option 1: Using Overleaf (Easiest, No Installation)

1. Go to https://www.overleaf.com (create free account)
2. Click "New Project" → "Upload Project"
3. Upload `CW1_Report.tex`
4. Take 11 screenshots from Wireshark
5. Upload all screenshots to Overleaf
6. Edit lines 32-33 to add your name and student ID
7. Click "Recompile"
8. Download PDF ✅

**Advantages**:
- No software installation needed
- Works on any computer
- Auto-saves your work
- Real-time PDF preview

### Option 2: Using the Compilation Script (If you have LaTeX)

```bash
# 1. Install LaTeX (if not installed)
brew install --cask mactex  # macOS

# 2. Navigate to report directory
cd /Users/macbookpro/DMR/CW1_PCAP_Analysis/report

# 3. Add your name/ID (edit lines 32-33 in CW1_Report.tex)

# 4. Take and save 11 screenshots (see guide below)

# 5. Compile
./compile.sh

# 6. Open the PDF
open CW1_Report.pdf
```

### Option 3: Auto-Replace Screenshots (If named correctly)

```bash
# 1. Take screenshots and name them:
#    screenshot1_wireshark_interface.png
#    screenshot2_conversations.png
#    ... (see full list below)

# 2. Run replacement script (dry run first)
python3 add_screenshots.py

# 3. Apply replacements
python3 add_screenshots.py apply

# 4. Compile
./compile.sh
```

---

## 📸 Screenshot Requirements

You need to take **11 screenshots** from Wireshark. Here's the quick list:

| # | Filename | What to Capture |
|---|----------|----------------|
| 1 | `screenshot1_wireshark_interface.png` | Wireshark main window with PCAP loaded |
| 2 | `screenshot2_conversations.png` | Statistics → Conversations (IPv4 tab) |
| 3 | `screenshot3_filter_post.png` | Filter: `http.request.method == "POST"` |
| 4 | `screenshot4_export_objects.png` | File → Export Objects → HTTP |
| 5 | `screenshot5_initial_download.png` | Frame 1735 (GET documents.zip) |
| 6 | `screenshot6_tls_sni.png` | TLS SNI for finejewels.com.au |
| 7 | `screenshot7_certificate.png` | Certificate showing Go Daddy CA |
| 8 | `screenshot8_c2_beacon.png` | Frame 3822 (POST to maldivehost.net) |
| 9 | `screenshot9_dns_ipify.png` | DNS query to api.ipify.org |
| 10 | `screenshot10_smtp_mailfrom.png` | Frame 28576 (MAIL FROM) |
| 11 | `screenshot11_smtp_auth.png` | Frame 28763 (SMTP password) |

**Detailed instructions**: See `report/LATEX_COMPILATION_GUIDE.md`

**Screenshot tips**:
- Use Cmd+Shift+4 (macOS) to capture selected area
- Save as PNG format
- Make sure screenshots are clear and readable
- Highlight important parts (use Wireshark's packet highlighting)

---

## 📋 What the LaTeX Report Looks Like

```
┌─────────────────────────────────────┐
│     TITLE PAGE                      │
│  - Report title                     │
│  - Your name [EDIT THIS]            │
│  - Student ID [EDIT THIS]           │
│  - Date                             │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│     ABSTRACT                        │
│  - Brief summary of analysis        │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│     TABLE OF CONTENTS               │
│  - Auto-generated                   │
│  - Section/subsection links         │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│  1. INTRODUCTION                    │
│     - Context and scope             │
│     - Figure 1: Wireshark Interface │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│  2. METHODOLOGY                     │
│     2.1 Tools and Environment       │
│     2.2 Analysis Approach           │
│         - Figure 2: Conversations   │
│     2.3 Specific Techniques         │
│         - Figure 3: Filter Example  │
│         - Figure 4: Export Objects  │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│  3. RESULTS                         │
│     3.1 Initial Compromise          │
│         - Figure 5: Initial Download│
│     3.2 Secondary Infections        │
│         - Figure 6: TLS SNI         │
│         - Figure 7: Certificate     │
│     3.3 C2 Establishment            │
│         - Figure 8: C2 Beaconing    │
│     3.4 Post-Exploitation           │
│         - Figure 9: DNS ipify       │
│         - Figure 10: SMTP MAIL FROM │
│         - Figure 11: SMTP Auth      │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│  4. CONCLUSION & PREVENTION         │
│     4.1 Summary                     │
│     4.2 IOCs                        │
│     4.3 Recommendations             │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│     REFERENCES                      │
│  - IEEE format                      │
│  - 5 citations                      │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│     APPENDIX: AI DECLARATION        │
│  - Required by assignment           │
└─────────────────────────────────────┘
```

---

## ⚙️ Customization Options

### If Report is Over 10 Pages:

**Reduce margins**:
```latex
% Line 6: Change from 1in to 0.8in
\usepackage[margin=0.8in]{geometry}
```

**Reduce screenshot sizes**:
```latex
% Change from 0.9 to 0.7
\includegraphics[width=0.7\textwidth]{screenshot.png}
```

**Reduce font size**:
```latex
% Line 1: Change from 11pt to 10pt
\documentclass[10pt,a4paper]{article}
```

### Add Your Details:

**Line 32-33**:
```latex
\textbf{John Smith}\\                     % ← Your name
\textbf{Student ID}: 123456789\\          % ← Your ID
```

---

## 📊 Report Statistics

- **Word Count**: ~980 words (excluding screenshots/references)
- **Figures**: 11 with captions
- **Sections**: 4 main + appendix
- **References**: 5 (IEEE format)
- **Expected Pages**: 8-10 (with screenshots)

---

## ✅ Before Submitting

1. [ ] Added your name and student ID (lines 32-33)
2. [ ] Took all 11 screenshots
3. [ ] Added screenshots to LaTeX (manually or via script)
4. [ ] Compiled to PDF successfully
5. [ ] Checked PDF page count ≤ 10 pages
6. [ ] Reviewed entire PDF for errors
7. [ ] All figures visible and properly captioned
8. [ ] Ready to submit `CW1_Report.pdf` to DLE

---

## 🆘 Troubleshooting

**"I don't have LaTeX installed"**
→ Use Overleaf (https://www.overleaf.com) - no installation needed!

**"Compilation fails"**
→ See `LATEX_COMPILATION_GUIDE.md` for common errors

**"Screenshots don't appear"**
→ Make sure images are in the same directory as .tex file

**"Over 10 pages"**
→ Reduce margins to 0.8in or screenshot sizes to 0.7\textwidth

**"Still prefer Markdown"**
→ That's fine! Use `CW1_Final_Report.md` instead

---

## 🎓 Why LaTeX?

**Advantages**:
✅ Professional academic appearance
✅ Automatic table of contents
✅ Automatic figure numbering and captions
✅ Perfect formatting every time
✅ Easy to adjust margins/spacing
✅ IEEE-style references built-in
✅ No manual formatting headaches

**Disadvantages**:
❌ Requires compilation step
❌ Learning curve for LaTeX syntax
❌ May need to install software (or use Overleaf)

---

## 📁 All Files Location

```
/Users/macbookpro/DMR/CW1_PCAP_Analysis/report/
├── CW1_Report.tex                  ← Main LaTeX file
├── compile.sh                      ← Compilation script
├── add_screenshots.py              ← Screenshot helper
├── README_LATEX.md                 ← Quick start
├── LATEX_COMPILATION_GUIDE.md      ← Detailed guide
└── CW1_Final_Report.md             ← Markdown alternative
```

---

## 🚀 Next Steps

1. **Choose your path**:
   - Path A: LaTeX via Overleaf (easiest, recommended)
   - Path B: LaTeX locally (if you have/install MacTeX)
   - Path C: Markdown (more manual work)

2. **Take 11 screenshots** following the guide

3. **Compile to PDF**

4. **Submit** before November 3, 2025, 15:00

---

**You're ready to create a professional PDF report!** 🎉

Choose Overleaf for the easiest experience, or use the compilation script if you have LaTeX installed.

Good luck with your submission! 🚀

