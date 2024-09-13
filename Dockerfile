# Use the official Pi-hole Docker image
FROM pihole/pihole:latest

# Set the timezone (TZ) environment variable
ENV TZ="Europe/Amsterdam"

# Install required packages: curl, bash, and unbound
RUN apt-get update && \
    apt-get install -y curl bash unbound && \
    apt-get clean

# Unbound configuration for Pi-hole with DNSSEC
RUN mkdir -p /etc/unbound/unbound.conf.d/ && \
    echo 'server:
            interface: 0.0.0.0
            access-control: 10.0.0.0/16 allow
            do-ip4: yes
            do-udp: yes
            do-tcp: yes
            prefer-ip6: no
            hide-identity: yes
            hide-version: yes
            harden-glue: yes
            harden-dnssec-stripped: yes
            use-caps-for-id: yes
            edns-buffer-size: 1232
            cache-min-ttl: 3600
            cache-max-ttl: 86400
            prefetch: yes
            prefetch-key: yes
            num-threads: 4
            # DNSSEC validation
            auto-trust-anchor-file: "/var/lib/unbound/root.key"
            # Pi-hole specific FTL
            private-address: 10.0.0.0/16' > /etc/unbound/unbound.conf.d/pi-hole.conf

# Download the latest root trust anchor for DNSSEC
RUN unbound-anchor -a /var/lib/unbound/root.key

# Add blocklists to Pi-hole
RUN pihole -b https://someblocklisturl1.com/list.txt && \
    pihole -b https://someblocklisturl2.com/list.txt

# Add regex filters to Pi-hole
RUN curl -sSL https://someurl.com/regexlist.txt | while read -r regex; do \
      pihole --regex "$regex"; \
    done

# Update Pi-hole gravity to apply blocklists and regexes
RUN pihole -g

# Expose necessary ports (53/UDP, 80/TCP, 443/TCP)
EXPOSE 53/udp 80/tcp 443/tcp

# Start Unbound and Pi-hole services when container starts
CMD [ "/bin/bash", "-c", "unbound -d & pihole-FTL" ]
