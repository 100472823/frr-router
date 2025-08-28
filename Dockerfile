FROM debian:bullseye

# Instalar FRR 8.2
RUN apt-get update && \
    apt-get install -y curl gnupg lsb-release && \
    curl -s https://deb.frrouting.org/frr/keys.asc | gpg --dearmor -o /usr/share/keyrings/frr.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/frr.gpg] https://deb.frrouting.org/frr $(lsb_release -cs) frr-8.2" > /etc/apt/sources.list.d/frr.list && \
    apt-get update && \
    apt-get install -y frr frr-pythontools && \
    apt-get clean

# Crear /var/run/frr y dar permisos a frr:frr
RUN mkdir -p /var/run/frr && chown frr:frr /var/run/frr

# Copiar configuración
COPY frr.conf /etc/frr/frr.conf
RUN echo "no service integrated-vtysh-config" > /etc/frr/vtysh.conf

# Activar demonios
RUN echo "zebra=yes" > /etc/frr/daemons && \
    echo "ripd=yes" >> /etc/frr/daemons && \
    echo "ospfd=yes" >> /etc/frr/daemons && \
    echo "bgpd=yes" >> /etc/frr/daemons && \
    echo 'zebra_options="  -A 0.0.0.0"' >> /etc/frr/daemons && \
    echo 'ripd_options="   -A 0.0.0.0"' >> /etc/frr/daemons && \
    echo 'ospfd_options=" -A 0.0.0.0"' >> /etc/frr/daemons && \
    echo 'bgpd_options="  -A 0.0.0.0"' >> /etc/frr/daemons

# Configurar watchfrr
RUN echo "zebra=yes" > /etc/frr/watchfrr.conf && \
    echo "ripd=yes" >> /etc/frr/watchfrr.conf && \
    echo "ospfd=yes" >> /etc/frr/watchfrr.conf && \
    echo "bgpd=yes" >> /etc/frr/watchfrr.conf

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]

