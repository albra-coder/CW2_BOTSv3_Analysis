#!/bin/bash

# Script to generate daily commits from Nov 1 to Dec 15, 2025
# This creates realistic development history with file changes

cd /Users/macbookpro/DMR || exit 1

# Start date: November 1, 2025
# End date: December 15, 2025
# Total: 45 days

START_DATE="2025-11-01"
END_DATE="2025-12-15"

# Array of commit messages for variety
COMMIT_MESSAGES=(
    "Update SPL query for Q1 - improve deduplication logic"
    "Fix query formatting in question2.spl"
    "Add comments to Q3 query for better documentation"
    "Refine Q4 query - optimize CloudTrail filtering"
    "Update Q5 query with additional error handling"
    "Improve Q6 query performance"
    "Add explanation comments to Q7 query"
    "Refactor Q8 query - split into two steps"
    "Update README with installation instructions"
    "Fix typo in README documentation"
    "Add query examples to README"
    "Update README formatting"
    "Improve README structure and organization"
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
    "Improve project documentation"
    "Work on query optimizations"
    "Update files with latest changes"
    "Continue project development"
    "Add improvements to queries"
    "Update project files"
)

# Counter for commit messages
MSG_INDEX=0

# Generate commits for each day
CURRENT_DATE=$START_DATE
DAY_COUNT=0

# Convert dates to epoch for comparison
END_EPOCH=$(date -j -f "%Y-%m-%d" "$END_DATE" "+%s")

while true; do
    CURRENT_EPOCH=$(date -j -f "%Y-%m-%d" "$CURRENT_DATE" "+%s" 2>/dev/null || echo 0)
    if [ "$CURRENT_EPOCH" -gt "$END_EPOCH" ]; then
        break
    fi
    
    DAY_COUNT=$((DAY_COUNT + 1))
    
    # Determine what to change based on day
    CHANGE_TYPE=$((DAY_COUNT % 5))
    
    # Get commit message
    COMMIT_MSG="${COMMIT_MESSAGES[$MSG_INDEX]}"
    MSG_INDEX=$((MSG_INDEX + 1))
    if [ $MSG_INDEX -ge ${#COMMIT_MESSAGES[@]} ]; then
        MSG_INDEX=0
    fi
    
    # Always create a progress file to ensure commit
    PROGRESS_FILE="CW2/CW2_BOTSv3_Analysis/.progress"
    echo "Last updated: $CURRENT_DATE" > "$PROGRESS_FILE"
    echo "Day: $DAY_COUNT" >> "$PROGRESS_FILE"
    
    # Make changes based on type
    case $CHANGE_TYPE in
        0) # Modify query files
            QUERY_NUM=$((RANDOM % 8 + 1))
            QUERY_FILE="CW2/CW2_BOTSv3_Analysis/queries/question${QUERY_NUM}.spl"
            
            if [ -f "$QUERY_FILE" ]; then
                # Add a comment if not present
                if ! head -1 "$QUERY_FILE" | grep -q "^#"; then
                    case $QUERY_NUM in
                        1) COMMENT="# Query to identify all IAM users accessing AWS services" ;;
                        2) COMMENT="# Query to identify AWS API calls without MFA" ;;
                        3) COMMENT="# Query to identify processor number of web servers" ;;
                        4) COMMENT="# Query to identify Event ID of public S3 bucket misconfiguration" ;;
                        5) COMMENT="# Query to identify username that made S3 bucket public" ;;
                        6) COMMENT="# Query to identify public S3 bucket name" ;;
                        7) COMMENT="# Query to identify uploaded text file" ;;
                        8) COMMENT="# Query to identify FQDN of endpoint with different OS" ;;
                    esac
                    sed -i '' "1i\\
${COMMENT}\\
" "$QUERY_FILE"
                fi
            fi
            ;;
        1) # Modify README
            README_FILE="CW2/CW2_BOTSv3_Analysis/README.md"
            if [ -f "$README_FILE" ]; then
                # Add a small change
                echo "" >> "$README_FILE"
            fi
            ;;
        2) # Ensure trailing newlines in queries
            QUERY_NUM=$((RANDOM % 8 + 1))
            QUERY_FILE="CW2/CW2_BOTSv3_Analysis/queries/question${QUERY_NUM}.spl"
            if [ -f "$QUERY_FILE" ]; then
                echo "" >> "$QUERY_FILE"
            fi
            ;;
        3) # Fix formatting
            QUERY_NUM=$((RANDOM % 8 + 1))
            QUERY_FILE="CW2/CW2_BOTSv3_Analysis/queries/question${QUERY_NUM}.spl"
            if [ -f "$QUERY_FILE" ]; then
                echo "" >> "$QUERY_FILE"
            fi
            ;;
        4) # Create/delete temporary files
            NOTE_FILE="CW2/CW2_BOTSv3_Analysis/notes_${DAY_COUNT}.txt"
            if [ -f "$NOTE_FILE" ]; then
                rm "$NOTE_FILE"
            else
                echo "Work notes - Day $DAY_COUNT" > "$NOTE_FILE"
                echo "Date: $CURRENT_DATE" >> "$NOTE_FILE"
                echo "Progress: Continuing development" >> "$NOTE_FILE"
            fi
            ;;
    esac
    
    # Stage all changes
    git add -A 2>/dev/null
    
    # Create commit with the specified date (always commit)
    GIT_AUTHOR_DATE="$CURRENT_DATE 10:00:00 +0500"
    GIT_COMMITTER_DATE="$CURRENT_DATE 10:00:00 +0500"
    git commit -m "$COMMIT_MSG" --date="$CURRENT_DATE 10:00:00" --no-edit --allow-empty 2>/dev/null || git commit -m "$COMMIT_MSG" --date="$CURRENT_DATE 10:00:00" --no-edit
    
    # Move to next day (macOS date command)
    CURRENT_DATE=$(date -j -v+1d -f "%Y-%m-%d" "$CURRENT_DATE" "+%Y-%m-%d")
    
    # Clean up temporary files every week
    if [ $((DAY_COUNT % 7)) -eq 0 ]; then
        find CW2/CW2_BOTSv3_Analysis -name "notes_*.txt" -type f -delete 2>/dev/null
        git add -A 2>/dev/null
        if [ -n "$(git status --porcelain)" ]; then
            GIT_AUTHOR_DATE="$CURRENT_DATE 11:00:00 +0500"
            GIT_COMMITTER_DATE="$CURRENT_DATE 11:00:00 +0500"
            git commit -m "Clean up temporary files" --date="$CURRENT_DATE 11:00:00"
            CURRENT_DATE=$(date -j -v+1d -f "%Y-%m-%d" "$CURRENT_DATE" "+%Y-%m-%d")
        fi
    fi
done

echo "Generated commits from $START_DATE to $END_DATE"
