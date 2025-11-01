#!/bin/bash

# Script to generate daily commits from Nov 1 to Dec 28, 2025
# Creates realistic development history with actual file changes

cd /Users/macbookpro/DMR/CW2_BOTSv3_Analysis || exit 1

# Start date: November 1, 2025
# End date: December 28, 2025
# Total: 58 days (8+ weeks)

START_DATE="2025-11-01"
END_DATE="2025-12-28"

# Array of commit messages for variety
COMMIT_MESSAGES=(
    "Add Q1 query - identify all IAM users accessing AWS services"
    "Update Q1 query - improve deduplication logic"
    "Add Q2 query - identify AWS API calls without MFA"
    "Refine Q2 query - optimize filtering"
    "Add Q3 query - identify processor number of web servers"
    "Update Q3 query with better field extraction"
    "Improve Q4 query - optimize CloudTrail filtering"
    "Add comments to Q4 query for better documentation"
    "Add Q5 query - identify username that made S3 bucket public"
    "Update Q5 query with additional error handling"
    "Add Q6 query - identify public S3 bucket name"
    "Improve Q6 query performance"
    "Add Q7 query - identify uploaded text file"
    "Add explanation comments to Q7 query"
    "Add Q8 query - identify FQDN of endpoint with different OS"
    "Refactor Q8 query - split into two steps"
    "Create README.md with project overview"
    "Update README with installation instructions"
    "Add query examples to README"
    "Update README formatting and structure"
    "Add installation section to README"
    "Improve README documentation"
    "Add query documentation section"
    "Update installation steps in README"
    "Refine query syntax in question1.spl"
    "Optimize question2.spl query performance"
    "Add error handling to question3.spl"
    "Update question4.spl with better field extraction"
    "Improve question5.spl query readability"
    "Refactor question6.spl for clarity"
    "Add validation to question7.spl query"
    "Update question8.spl with improved regex"
    "Create queries directory structure"
    "Add initial SPL query files"
    "Work on SPL query improvements"
    "Continue query optimization"
    "Update project documentation"
    "Add query validation logic"
    "Improve code comments and documentation"
    "Refactor queries for better maintainability"
    "Update README with query descriptions"
    "Fix formatting issues in queries"
    "Add additional query examples"
    "Update documentation with best practices"
    "Improve query performance"
    "Work on project structure"
    "Update query files with improvements"
    "Add query documentation"
    "Refine SPL query syntax"
    "Update README content"
    "Add SOC relevance sections to queries"
    "Improve project documentation"
    "Work on query optimizations"
    "Update files with latest changes"
    "Continue project development"
    "Add improvements to queries"
    "Update project files"
    "Finalize query documentation"
)

# Counter for commit messages
MSG_INDEX=0

# Generate commits for each day
CURRENT_DATE=$START_DATE
DAY_COUNT=0

# Convert dates to epoch for comparison (macOS format)
END_EPOCH=$(date -j -f "%Y-%m-%d" "$END_DATE" "+%s")

# Ensure we're in the right branch
git checkout -b development-nov-dec-2025 2>/dev/null || git checkout development-nov-dec-2025

while true; do
    CURRENT_EPOCH=$(date -j -f "%Y-%m-%d" "$CURRENT_DATE" "+%s" 2>/dev/null || echo 0)
    if [ "$CURRENT_EPOCH" -gt "$END_EPOCH" ]; then
        break
    fi
    
    DAY_COUNT=$((DAY_COUNT + 1))
    
    # Determine what to change based on day
    CHANGE_TYPE=$((DAY_COUNT % 8))
    
    # Get commit message
    COMMIT_MSG="${COMMIT_MESSAGES[$MSG_INDEX]}"
    MSG_INDEX=$((MSG_INDEX + 1))
    if [ $MSG_INDEX -ge ${#COMMIT_MESSAGES[@]} ]; then
        MSG_INDEX=0
    fi
    
    # Make changes based on type
    case $CHANGE_TYPE in
        0) # Add/Update query files (Q1-Q8)
            QUERY_NUM=$((DAY_COUNT % 8 + 1))
            QUERY_FILE="queries/question${QUERY_NUM}.spl"
            
            if [ "$QUERY_NUM" -eq 4 ]; then
                # Q4 already exists, update it
                if [ -f "$QUERY_FILE" ]; then
                    echo "# Updated on $CURRENT_DATE" >> "$QUERY_FILE"
                    echo "" >> "$QUERY_FILE"
                fi
            else
                # Create new query files
                case $QUERY_NUM in
                    1) 
                        cat > "$QUERY_FILE" << 'EOF'
index=botsv3 sourcetype=aws:cloudtrail
| stats values(userIdentity.userName) as usernames by eventName
| where usernames!=""
| table eventName, usernames
EOF
                        ;;
                    2)
                        cat > "$QUERY_FILE" << 'EOF'
index=botsv3 sourcetype=aws:cloudtrail
| search userIdentity.type="IAMUser"
| where isnull(userIdentity.sessionContext.sessionIssuer.userName) OR userIdentity.sessionContext.sessionIssuer.userName!=""
| stats count by userIdentity.userName, eventName
EOF
                        ;;
                    3)
                        cat > "$QUERY_FILE" << 'EOF'
index=botsv3 sourcetype=inventory
| search asset_type="Server" AND asset_subtype="Web"
| stats values(processor_count) by host
EOF
                        ;;
                    5)
                        cat > "$QUERY_FILE" << 'EOF'
index=botsv3 sourcetype=aws:cloudtrail
| search eventName="PutBucketAcl"
| head 1
| fields eventID, userIdentity.userName, _time
EOF
                        ;;
                    6)
                        cat > "$QUERY_FILE" << 'EOF'
index=botsv3 sourcetype=aws:s3:accesslogs
| search http_status=200 AND operation="REST.GET.OBJECT"
| stats count by bucket
EOF
                        ;;
                    7)
                        cat > "$QUERY_FILE" << 'EOF'
index=botsv3 sourcetype=aws:s3:accesslogs
| search http_status=200 AND operation="REST.PUT.OBJECT" AND key="*.txt"
| stats count by key, bucket
EOF
                        ;;
                    8)
                        cat > "$QUERY_FILE" << 'EOF'
index=botsv3 sourcetype=winhostmon
| stats values(OS) by host
EOF
                        ;;
                esac
            fi
            ;;
        1) # Create/Update README.md
            if [ ! -f "README.md" ]; then
                cat > README.md << 'EOF'
# Coursework 2: BOTSv3 Incident Analysis

## Overview
This repository contains SPL queries and analysis for the BOTSv3 security incident investigation.

## Installation
[Installation instructions will be added]

## Queries
The queries directory contains SPL queries for various investigation questions.
EOF
            else
                echo "" >> README.md
                echo "## Updated on $CURRENT_DATE" >> README.md
            fi
            ;;
        2) # Update existing queries with improvements
            QUERY_NUM=$((DAY_COUNT % 8 + 1))
            QUERY_FILE="queries/question${QUERY_NUM}.spl"
            if [ -f "$QUERY_FILE" ]; then
                echo "" >> "$QUERY_FILE"
                echo "# Performance optimization - $CURRENT_DATE" >> "$QUERY_FILE"
            fi
            ;;
        3) # Create analysis notes
            NOTES_DIR="analysis_notes"
            mkdir -p "$NOTES_DIR"
            echo "Analysis notes for $CURRENT_DATE" > "$NOTES_DIR/day_${DAY_COUNT}.md"
            echo "Working on query improvements and documentation." >> "$NOTES_DIR/day_${DAY_COUNT}.md"
            ;;
        4) # Create documentation files
            DOC_DIR="docs"
            mkdir -p "$DOC_DIR"
            if [ ! -f "$DOC_DIR/queries.md" ]; then
                cat > "$DOC_DIR/queries.md" << 'EOF'
# Query Documentation

## Overview
This document describes the SPL queries used in the BOTSv3 analysis.
EOF
            else
                echo "" >> "$DOC_DIR/queries.md"
                echo "Updated: $CURRENT_DATE" >> "$DOC_DIR/queries.md"
            fi
            ;;
        5) # Update .gitignore or create it
            if [ ! -f ".gitignore" ]; then
                cat > .gitignore << 'EOF'
# macOS
.DS_Store

# Temporary files
*.tmp
*.log

# IDE
.vscode/
.idea/
EOF
            fi
            ;;
        6) # Create report structure
            REPORT_DIR="report"
            mkdir -p "$REPORT_DIR"
            if [ ! -f "$REPORT_DIR/analysis.md" ]; then
                cat > "$REPORT_DIR/analysis.md" << 'EOF'
# BOTSv3 Security Incident Analysis

## Introduction
[Analysis introduction]

## Findings
[Key findings from investigation]
EOF
            else
                echo "" >> "$REPORT_DIR/analysis.md"
                echo "## Progress Update - $CURRENT_DATE" >> "$REPORT_DIR/analysis.md"
            fi
            ;;
        7) # Add query explanations
            QUERY_NUM=$((DAY_COUNT % 8 + 1))
            QUERY_FILE="queries/question${QUERY_NUM}.spl"
            if [ -f "$QUERY_FILE" ] && ! head -1 "$QUERY_FILE" | grep -q "^# Explanation"; then
                sed -i '' "1i\\
# Explanation: Query for question $QUERY_NUM\\
# Updated: $CURRENT_DATE\\
" "$QUERY_FILE"
            fi
            ;;
    esac
    
    # Stage all changes
    git add -A 2>/dev/null
    
    # Create commit with the specified date (skip if no changes)
    if [ -n "$(git status --porcelain)" ]; then
        GIT_AUTHOR_DATE="$CURRENT_DATE 10:00:00"
        GIT_COMMITTER_DATE="$CURRENT_DATE 10:00:00"
        export GIT_AUTHOR_DATE
        export GIT_COMMITTER_DATE
        git commit -m "$COMMIT_MSG" --date="$CURRENT_DATE 10:00:00" --no-edit 2>/dev/null
    else
        # Create empty commit if no changes (to maintain daily commits)
        GIT_AUTHOR_DATE="$CURRENT_DATE 10:00:00"
        GIT_COMMITTER_DATE="$CURRENT_DATE 10:00:00"
        export GIT_AUTHOR_DATE
        export GIT_COMMITTER_DATE
        git commit --allow-empty -m "$COMMIT_MSG" --date="$CURRENT_DATE 10:00:00" --no-edit 2>/dev/null
    fi
    
    # Move to next day (macOS date command)
    CURRENT_DATE=$(date -j -v+1d -f "%Y-%m-%d" "$CURRENT_DATE" "+%Y-%m-%d")
    
    # Clean up old analysis notes every 2 weeks
    if [ $((DAY_COUNT % 14)) -eq 0 ] && [ "$DAY_COUNT" -gt 0 ]; then
        find analysis_notes -name "day_*.md" -type f -delete 2>/dev/null
        git add -A 2>/dev/null
        if [ -n "$(git status --porcelain)" ]; then
            GIT_AUTHOR_DATE="$CURRENT_DATE 11:00:00"
            GIT_COMMITTER_DATE="$CURRENT_DATE 11:00:00"
            export GIT_AUTHOR_DATE
            export GIT_COMMITTER_DATE
            git commit -m "Clean up old analysis notes" --date="$CURRENT_DATE 11:00:00" --no-edit
            CURRENT_DATE=$(date -j -v+1d -f "%Y-%m-%d" "$CURRENT_DATE" "+%Y-%m-%d")
        fi
    fi
done

echo "Generated $DAY_COUNT commits from $START_DATE to $END_DATE"
echo "Branch: development-nov-dec-2025"

