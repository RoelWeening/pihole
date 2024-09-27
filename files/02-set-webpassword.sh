# Copy the WEBPASSWORD script
COPY files/02-set-webpassword.sh /etc/cont-init.d/02-set-webpassword.sh

# Ensure the script is executable
RUN chmod +x /etc/cont-init.d/02-set-webpassword.sh
