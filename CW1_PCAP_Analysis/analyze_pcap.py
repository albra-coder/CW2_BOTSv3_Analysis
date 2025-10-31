#!/usr/bin/env python3
"""
COMP3010 CW1 - PCAP Analysis Script
Analyzes network traffic to answer all coursework questions
"""

from scapy.all import rdpcap, TCP, UDP, IP, DNS, Raw
from scapy.layers.http import HTTPRequest, HTTPResponse, HTTP
try:
    from scapy.layers.tls.all import TLS
except ImportError:
    TLS = None
from collections import defaultdict
import datetime

print("Loading PCAP file...")
pcap_file = "pcap_files/cw1 4.pcap"
packets = rdpcap(pcap_file)
print(f"Loaded {len(packets)} packets\n")

# Data structures to store findings
http_requests = []
http_responses = []
dns_queries = []
tls_connections = []
smtp_packets = []
conversations = defaultdict(int)

print("="*80)
print("INITIAL RECONNAISSANCE")
print("="*80)

# Get time range
first_packet = packets[0]
last_packet = packets[-1]
print(f"Capture time range:")
print(f"  Start: {datetime.datetime.fromtimestamp(float(first_packet.time))}")
print(f"  End: {datetime.datetime.fromtimestamp(float(last_packet.time))}")
print()

# Identify protocols
protocols = defaultdict(int)
for pkt in packets:
    if pkt.haslayer(TCP):
        protocols['TCP'] += 1
    if pkt.haslayer(UDP):
        protocols['UDP'] += 1
    if pkt.haslayer(DNS):
        protocols['DNS'] += 1
    if pkt.haslayer(HTTP):
        protocols['HTTP'] += 1
    if TLS and pkt.haslayer(TLS):
        protocols['TLS'] += 1
    elif pkt.haslayer(TCP) and pkt[TCP].dport == 443 or (pkt.haslayer(TCP) and pkt[TCP].sport == 443):
        protocols['TLS/SSL'] += 1

print("Protocol Distribution:")
for proto, count in sorted(protocols.items(), key=lambda x: x[1], reverse=True):
    print(f"  {proto}: {count}")
print()

# Find internal IP (most common source)
ip_count = defaultdict(int)
for pkt in packets:
    if pkt.haslayer(IP):
        ip_count[pkt[IP].src] += 1

print("Top 10 Source IPs:")
for ip, count in sorted(ip_count.items(), key=lambda x: x[1], reverse=True)[:10]:
    print(f"  {ip}: {count} packets")
print()

print("="*80)
print("PART 1: INITIAL INFECTION & FILE TRANSFER")
print("="*80)

# Analyze HTTP traffic
print("\nAnalyzing HTTP requests...")
for pkt in packets:
    if pkt.haslayer(HTTPRequest):
        http_req = pkt[HTTPRequest]
        timestamp = datetime.datetime.fromtimestamp(float(pkt.time))
        method = http_req.Method.decode() if http_req.Method else 'Unknown'
        host = http_req.Host.decode() if http_req.Host else 'Unknown'
        path = http_req.Path.decode() if http_req.Path else 'Unknown'
        
        http_requests.append({
            'time': timestamp,
            'packet_num': packets.index(pkt) + 1,
            'method': method,
            'host': host,
            'path': path,
            'full_url': f"{host}{path}",
            'src_ip': pkt[IP].src if pkt.haslayer(IP) else 'Unknown'
        })

# Sort by time
http_requests.sort(key=lambda x: x['time'])

print(f"\nFound {len(http_requests)} HTTP requests")
print("\nFirst 10 HTTP requests:")
for i, req in enumerate(http_requests[:10], 1):
    print(f"{i}. [{req['time']}] {req['method']} {req['full_url']}")

# Look for file downloads (GET requests with file extensions)
file_extensions = ['.zip', '.exe', '.dll', '.scr', '.7z', '.rar', '.gz', '.bin']
file_downloads = []
for req in http_requests:
    if req['method'] == 'GET':
        for ext in file_extensions:
            if ext in req['path'].lower():
                file_downloads.append(req)
                break

print(f"\n\nPotential file downloads ({len(file_downloads)}):")
for i, dl in enumerate(file_downloads, 1):
    filename = dl['path'].split('/')[-1]
    print(f"{i}. [{dl['time']}] {dl['host']} -> {filename}")

# Analyze HTTP responses for Server headers
print("\n\nAnalyzing HTTP responses for Server headers...")
for pkt in packets:
    if pkt.haslayer(HTTPResponse):
        http_resp = pkt[HTTPResponse]
        timestamp = datetime.datetime.fromtimestamp(float(pkt.time))
        
        # Try to extract Server header
        if hasattr(http_resp, 'Server'):
            server = http_resp.Server.decode() if http_resp.Server else None
        else:
            # Parse raw headers
            server = None
            if pkt.haslayer(Raw):
                raw_data = bytes(pkt[Raw])
                if b'Server:' in raw_data:
                    try:
                        server_line = [line for line in raw_data.split(b'\r\n') if line.startswith(b'Server:')]
                        if server_line:
                            server = server_line[0].decode().replace('Server: ', '').strip()
                    except:
                        pass
        
        http_responses.append({
            'time': timestamp,
            'packet_num': packets.index(pkt) + 1,
            'server': server,
            'dst_ip': pkt[IP].dst if pkt.haslayer(IP) else 'Unknown'
        })

# Find server headers
servers_found = [(r['time'], r['server']) for r in http_responses if r['server']]
if servers_found:
    print(f"Found {len(servers_found)} responses with Server headers:")
    for time, server in servers_found[:5]:
        print(f"  [{time}] {server}")

print("\n\n" + "="*80)
print("PART 2: DNS ANALYSIS")
print("="*80)

# Analyze DNS queries
for pkt in packets:
    if pkt.haslayer(DNS) and pkt[DNS].qr == 0:  # DNS query
        timestamp = datetime.datetime.fromtimestamp(float(pkt.time))
        qname = pkt[DNS].qd.qname.decode() if pkt[DNS].qd.qname else 'Unknown'
        dns_queries.append({
            'time': timestamp,
            'packet_num': packets.index(pkt) + 1,
            'query': qname.rstrip('.'),
            'src_ip': pkt[IP].src if pkt.haslayer(IP) else 'Unknown'
        })

print(f"\nFound {len(dns_queries)} DNS queries")
print("\nFirst 20 DNS queries:")
for i, query in enumerate(dns_queries[:20], 1):
    print(f"{i}. [{query['time']}] {query['query']}")

# Look for IP check services
ip_check_services = ['ipify', 'checkip', 'icanhazip', 'whatismyip', 'myip']
ip_check_queries = []
for query in dns_queries:
    for service in ip_check_services:
        if service in query['query'].lower():
            ip_check_queries.append(query)
            break

if ip_check_queries:
    print(f"\n\nIP Check Services Detected ({len(ip_check_queries)}):")
    for q in ip_check_queries:
        print(f"  [{q['time']}] {q['query']}")

print("\n\n" + "="*80)
print("PART 3: TLS/HTTPS ANALYSIS")
print("="*80)

# Analyze TLS traffic (looking for SNI)
tls_count = 0
tls_domains = []
for pkt in packets:
    is_tls = False
    if TLS and pkt.haslayer(TLS):
        is_tls = True
    elif pkt.haslayer(TCP) and (pkt[TCP].dport == 443 or pkt[TCP].sport == 443):
        is_tls = True
    
    if is_tls:
        tls_count += 1
        timestamp = datetime.datetime.fromtimestamp(float(pkt.time))

print(f"\nFound {tls_count} TLS/HTTPS packets")

print("\n\n" + "="*80)
print("CONVERSATIONS ANALYSIS")
print("="*80)

# Track IP conversations
for pkt in packets:
    if pkt.haslayer(IP):
        src = pkt[IP].src
        dst = pkt[IP].dst
        conv = tuple(sorted([src, dst]))
        conversations[conv] += 1

print("\nTop 15 IP Conversations:")
for i, (conv, count) in enumerate(sorted(conversations.items(), key=lambda x: x[1], reverse=True)[:15], 1):
    print(f"{i}. {conv[0]} <-> {conv[1]}: {count} packets")

print("\n\nAnalysis complete! Now analyzing for specific questions...")
print("="*80)

