#!/bin/bash

# COMP3010 CW1 - PCAP Analysis Helper Scripts
# These commands help you quickly analyze your PCAP file

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Set your PCAP file path here
PCAP_FILE="./pcap_files/your_file.pcap"

echo -e "${GREEN}=== COMP3010 PCAP Analysis Helper ===${NC}\n"

# Function to check if file exists
check_pcap() {
    if [ ! -f "$PCAP_FILE" ]; then
        echo -e "${RED}Error: PCAP file not found at $PCAP_FILE${NC}"
        echo "Please update PCAP_FILE variable in this script"
        exit 1
    fi
}

# 1. Basic Statistics
basic_stats() {
    echo -e "${YELLOW}=== Basic PCAP Statistics ===${NC}"
    check_pcap
    
    echo "Total packets:"
    tshark -r "$PCAP_FILE" -q -z io,stat,0
    
    echo -e "\nProtocol Hierarchy:"
    tshark -r "$PCAP_FILE" -q -z io,phs
    
    echo -e "\nTime range:"
    tshark -r "$PCAP_FILE" -T fields -e frame.time | head -1
    echo "to"
    tshark -r "$PCAP_FILE" -T fields -e frame.time | tail -1
}

# 2. Find all HTTP requests
http_requests() {
    echo -e "${YELLOW}=== HTTP Requests ===${NC}"
    check_pcap
    tshark -r "$PCAP_FILE" -Y "http.request" -T fields \
        -e frame.time -e ip.src -e ip.dst -e http.host -e http.request.uri
}

# 3. Find HTTP downloads (GET requests)
http_downloads() {
    echo -e "${YELLOW}=== HTTP Downloads (GET requests) ===${NC}"
    check_pcap
    tshark -r "$PCAP_FILE" -Y "http.request.method == GET" -T fields \
        -e frame.time -e http.host -e http.request.uri -e http.user_agent
}

# 4. Extract HTTP objects (files)
extract_http_objects() {
    echo -e "${YELLOW}=== Extracting HTTP Objects ===${NC}"
    check_pcap
    mkdir -p ./extracted_files
    tshark -r "$PCAP_FILE" --export-objects http,./extracted_files
    echo "Files extracted to: ./extracted_files/"
    ls -lah ./extracted_files/
}

# 5. Find all DNS queries
dns_queries() {
    echo -e "${YELLOW}=== DNS Queries ===${NC}"
    check_pcap
    tshark -r "$PCAP_FILE" -Y "dns.flags.response == 0" -T fields \
        -e frame.time -e dns.qry.name | sort -u
}

# 6. Find TLS/HTTPS connections with SNI (domain names)
tls_sni() {
    echo -e "${YELLOW}=== TLS Server Names (HTTPS Domains) ===${NC}"
    check_pcap
    tshark -r "$PCAP_FILE" -Y "tls.handshake.extensions_server_name" -T fields \
        -e frame.time -e ip.dst -e tls.handshake.extensions_server_name | sort -u
}

# 7. Find all IP conversations
ip_conversations() {
    echo -e "${YELLOW}=== Top IP Conversations ===${NC}"
    check_pcap
    tshark -r "$PCAP_FILE" -q -z conv,ip | head -20
}

# 8. Find HTTP POST requests (potential C2 beaconing)
http_posts() {
    echo -e "${YELLOW}=== HTTP POST Requests ===${NC}"
    check_pcap
    tshark -r "$PCAP_FILE" -Y "http.request.method == POST" -T fields \
        -e frame.time -e ip.dst -e http.host -e frame.len
}

# 9. Find SMTP traffic (email)
smtp_traffic() {
    echo -e "${YELLOW}=== SMTP Traffic ===${NC}"
    check_pcap
    tshark -r "$PCAP_FILE" -Y "smtp" -T fields \
        -e frame.time -e ip.src -e ip.dst -e smtp.req.command -e smtp.req.parameter
}

# 10. Search for specific string in packets
search_string() {
    if [ -z "$1" ]; then
        echo "Usage: search_string <string>"
        return
    fi
    echo -e "${YELLOW}=== Searching for: $1 ===${NC}"
    check_pcap
    tshark -r "$PCAP_FILE" -Y "frame contains \"$1\"" -V
}

# 11. Get certificates from TLS connections
tls_certificates() {
    echo -e "${YELLOW}=== TLS Certificates ===${NC}"
    check_pcap
    tshark -r "$PCAP_FILE" -Y "tls.handshake.certificate" -T fields \
        -e frame.time -e ip.src -e x509ce.dNSName -e x509sat.printableString
}

# 12. Find traffic in time window (customize dates)
time_filter() {
    START_TIME=$1
    END_TIME=$2
    if [ -z "$START_TIME" ] || [ -z "$END_TIME" ]; then
        echo "Usage: time_filter 'YYYY-MM-DD HH:MM:SS' 'YYYY-MM-DD HH:MM:SS'"
        return
    fi
    echo -e "${YELLOW}=== Traffic between $START_TIME and $END_TIME ===${NC}"
    check_pcap
    tshark -r "$PCAP_FILE" -Y "frame.time >= \"$START_TIME\" && frame.time <= \"$END_TIME\""
}

# 13. Find unique User-Agent strings
user_agents() {
    echo -e "${YELLOW}=== Unique User-Agent Strings ===${NC}"
    check_pcap
    tshark -r "$PCAP_FILE" -Y "http.user_agent" -T fields -e http.user_agent | sort -u
}

# 14. Find HTTP Server headers
http_servers() {
    echo -e "${YELLOW}=== HTTP Server Headers ===${NC}"
    check_pcap
    tshark -r "$PCAP_FILE" -Y "http.response" -T fields \
        -e ip.src -e http.host -e http.server | sort -u
}

# Menu system
show_menu() {
    echo -e "\n${GREEN}Choose an analysis option:${NC}"
    echo "1)  Basic Statistics"
    echo "2)  HTTP Requests"
    echo "3)  HTTP Downloads (GET requests)"
    echo "4)  Extract HTTP Objects (files)"
    echo "5)  DNS Queries"
    echo "6)  TLS Server Names (HTTPS domains)"
    echo "7)  IP Conversations"
    echo "8)  HTTP POST Requests"
    echo "9)  SMTP Traffic"
    echo "10) Search for string in packets"
    echo "11) TLS Certificates"
    echo "12) Time-based filter"
    echo "13) User-Agent strings"
    echo "14) HTTP Server headers"
    echo "15) Run ALL analyses"
    echo "q)  Quit"
    echo -n "Enter choice: "
}

# Main loop
if [ "$1" == "menu" ] || [ -z "$1" ]; then
    while true; do
        show_menu
        read choice
        case $choice in
            1) basic_stats ;;
            2) http_requests ;;
            3) http_downloads ;;
            4) extract_http_objects ;;
            5) dns_queries ;;
            6) tls_sni ;;
            7) ip_conversations ;;
            8) http_posts ;;
            9) smtp_traffic ;;
            10) 
                echo -n "Enter search string: "
                read search_term
                search_string "$search_term"
                ;;
            11) tls_certificates ;;
            12) 
                echo -n "Enter start time (YYYY-MM-DD HH:MM:SS): "
                read start
                echo -n "Enter end time (YYYY-MM-DD HH:MM:SS): "
                read end
                time_filter "$start" "$end"
                ;;
            13) user_agents ;;
            14) http_servers ;;
            15)
                basic_stats
                http_requests
                dns_queries
                tls_sni
                ip_conversations
                http_posts
                smtp_traffic
                user_agents
                http_servers
                ;;
            q|Q) 
                echo "Goodbye!"
                exit 0
                ;;
            *) 
                echo -e "${RED}Invalid option${NC}"
                ;;
        esac
        echo -e "\nPress Enter to continue..."
        read
    done
else
    # Allow running functions directly
    $1 "${@:2}"
fi

