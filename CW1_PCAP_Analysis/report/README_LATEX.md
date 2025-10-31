# LaTeX Report - Quick Start Guide

## 📁 Files in this Directory

- **`CW1_Report.tex`**: Main LaTeX source file (ready to compile)
- **`compile.sh`**: Automated compilation script
- **`add_screenshots.py`**: Script to replace placeholders with images
- **`LATEX_COMPILATION_GUIDE.md`**: Detailed instructions

## 🚀 Quick Start (3 Steps)

### Step 1: Take Screenshots
Open `cw1 4.pcap` in Wireshark and take 11 screenshots according to `LATEX_COMPILATION_GUIDE.md`

Save them as:
- `screenshot1_wireshark_interface.png`
- `screenshot2_conversations.png`
- `screenshot3_filter_post.png`
- `screenshot4_export_objects.png`
- `screenshot5_initial_download.png`
- `screenshot6_tls_sni.png`
- `screenshot7_certificate.png`
- `screenshot8_c2_beacon.png`
- `screenshot9_dns_ipify.png`
- `screenshot10_smtp_mailfrom.png`
- `screenshot11_smtp_auth.png`

### Step 2: Add Your Details
Open `CW1_Report.tex` and edit lines 32-33:
```latex
\textbf{[Your Name]}\\          % ← Change this
\textbf{Student ID}: [Your Student ID]\\  % ← Change this
```

### Step 3: Compile to PDF

**Option A: Using the script (easiest)**
```bash
cd /Users/macbookpro/DMR/CW1_PCAP_Analysis/report
./compile.sh
```

**Option B: Manual compilation**
```bash
pdflatex CW1_Report.tex
pdflatex CW1_Report.tex  # Run twice for references
```

**Option C: Use Overleaf (no installation needed)**
1. Go to https://www.overleaf.com
2. Upload `CW1_Report.tex` and all screenshots
3. Click "Recompile"

## 🎯 What You Get

✅ Professional PDF report
✅ Automatic table of contents
✅ 11 figures with captions
✅ IEEE-style references
✅ ~980 words (within limit)
✅ Professional formatting

## 🔧 Optional: Replace Placeholders Automatically

If you have screenshots named correctly:

```bash
# Check what would be replaced (dry run)
python3 add_screenshots.py

# Apply the replacements
python3 add_screenshots.py apply

# Then compile
./compile.sh
```

## 📊 Current Report Structure

```
Title Page
  ↓
Abstract
  ↓
Table of Contents
  ↓
1. Introduction
   └─ Figure 1: Wireshark Interface
  ↓
2. Methodology
   ├─ Figure 2: Conversations
   ├─ Figure 3: Filter Example
   └─ Figure 4: Export Objects
  ↓
3. Results
   ├─ 3.1 Initial Compromise (Figure 5)
   ├─ 3.2 Secondary Infections (Figures 6-7)
   ├─ 3.3 C2 Establishment (Figure 8)
   └─ 3.4 Post-Exploitation (Figures 9-11)
  ↓
4. Conclusion & Prevention
  ↓
References
  ↓
Appendix: AI Declaration
```

## ⚠️ Before Submitting

1. ✅ Add your name and student ID
2. ✅ All 11 screenshots in place
3. ✅ Compile to PDF
4. ✅ Check page count ≤ 10 pages
5. ✅ Review entire PDF for errors
6. ✅ Submit `CW1_Report.pdf` to DLE

## 💡 Tips

- **Screenshots too large?** Reduce to `width=0.8\textwidth` or `0.7\textwidth`
- **Over 10 pages?** Reduce margins to `0.8in` or `0.75in`
- **Compilation error?** Use Overleaf (most foolproof)
- **No LaTeX installed?** Use Overleaf (online, free)

## 🆘 Troubleshooting

**"pdflatex: command not found"**
→ Install MacTeX or use Overleaf

**"File not found: screenshot.png"**
→ Make sure screenshots are in the same directory as the .tex file

**PDF has placeholder boxes instead of images**
→ Either run `add_screenshots.py apply` or manually replace the `\fbox` commands

**Over 10 pages**
→ Reduce image sizes or margins (see LATEX_COMPILATION_GUIDE.md)

## 📚 Need More Help?

See `LATEX_COMPILATION_GUIDE.md` for:
- Detailed screenshot instructions
- Multiple compilation methods
- Customization options
- Common error fixes

---

**The LaTeX file is complete and ready to use!**
Just add screenshots and compile. 🚀

