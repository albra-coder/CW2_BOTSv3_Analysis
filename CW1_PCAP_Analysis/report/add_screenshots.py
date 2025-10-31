#!/usr/bin/env python3
"""
COMP3010 CW1 - Screenshot Replacement Script
This script replaces placeholder boxes with actual screenshot images in the LaTeX file
"""

import re
import os
import sys

def replace_placeholders(tex_file, dry_run=True):
    """Replace placeholder boxes with actual image includes"""
    
    # Screenshot mapping
    screenshots = {
        1: "screenshot1_wireshark_interface.png",
        2: "screenshot2_conversations.png",
        3: "screenshot3_filter_post.png",
        4: "screenshot4_export_objects.png",
        5: "screenshot5_initial_download.png",
        6: "screenshot6_tls_sni.png",
        7: "screenshot7_certificate.png",
        8: "screenshot8_c2_beacon.png",
        9: "screenshot9_dns_ipify.png",
        10: "screenshot10_smtp_mailfrom.png",
        11: "screenshot11_smtp_auth.png",
    }
    
    # Read the LaTeX file
    with open(tex_file, 'r') as f:
        content = f.read()
    
    # Check which screenshots exist
    missing = []
    for num, filename in screenshots.items():
        if not os.path.exists(filename):
            missing.append(f"Screenshot {num}: {filename}")
    
    if missing:
        print("⚠️  WARNING: The following screenshot files are missing:")
        for m in missing:
            print(f"   - {m}")
        print()
        if not dry_run:
            response = input("Continue anyway? (y/n): ")
            if response.lower() != 'y':
                print("Aborted.")
                return False
    
    # Replace each placeholder
    replacements = 0
    for num, filename in screenshots.items():
        # Pattern to match placeholder boxes
        # Looking for: \fbox{\parbox{...}{\centering \vspace{...} \textbf{[SCREENSHOT X]} ... }}}
        pattern = r'\\fbox\{\\parbox\{[^}]+\}\{\\centering \\vspace\{[^}]+\} \\textbf\{\[SCREENSHOT ' + str(num) + r'\]\}.*?\}\}'
        
        # Replacement: \includegraphics[width=0.9\textwidth]{filename}
        replacement = r'\\includegraphics[width=0.9\\textwidth]{' + filename + '}'
        
        # Perform replacement
        new_content, count = re.subn(pattern, replacement, content, flags=re.DOTALL)
        if count > 0:
            content = new_content
            replacements += count
            print(f"✅ Replaced SCREENSHOT {num} with {filename}")
        else:
            print(f"❌ Could not find SCREENSHOT {num} placeholder")
    
    if dry_run:
        print()
        print("🔍 DRY RUN - No changes made")
        print(f"   Would replace {replacements} placeholders")
        print()
        print("To apply changes, run:")
        print("   python3 add_screenshots.py apply")
        return True
    
    # Write back to file
    backup_file = tex_file.replace('.tex', '_backup.tex')
    os.rename(tex_file, backup_file)
    
    with open(tex_file, 'w') as f:
        f.write(content)
    
    print()
    print(f"✅ Successfully replaced {replacements} placeholders")
    print(f"📄 Original file backed up to: {backup_file}")
    print()
    print("Next steps:")
    print("   1. Review the changes in CW1_Report.tex")
    print("   2. Compile: ./compile.sh")
    
    return True

def main():
    tex_file = "CW1_Report.tex"
    
    # Check if tex file exists
    if not os.path.exists(tex_file):
        print(f"❌ Error: {tex_file} not found!")
        print("   Make sure you're in the report directory")
        sys.exit(1)
    
    # Check if running in dry-run or apply mode
    dry_run = True
    if len(sys.argv) > 1 and sys.argv[1] == 'apply':
        dry_run = False
    
    print("=" * 50)
    print("COMP3010 CW1 - Screenshot Replacement")
    print("=" * 50)
    print()
    
    if dry_run:
        print("🔍 Running in DRY RUN mode (no changes will be made)")
    else:
        print("⚠️  APPLY mode - will modify CW1_Report.tex")
    
    print()
    
    success = replace_placeholders(tex_file, dry_run)
    
    if not success:
        sys.exit(1)

if __name__ == "__main__":
    main()

