#!/bin/sh

# Crear carpeta temporal de sockets
mkdir -p /var/run/frr
chown frr:frr /var/run/frr

# Crear interfaz dummy si no existe
ip link show dummy0 >/dev/null 2>&1 || {
    ip link add dummy0 type dummy
    ip addr add 192.168.100.1/24 dev dummy0
    ip link set dummy0 up
}

hostname frr-router

# Lanzar manualmente los demonios
/usr/lib/frr/zebra -d -A 0.0.0.0
/usr/lib/frr/ripd -d -A 0.0.0.0
/usr/lib/frr/ospfd -d -A 0.0.0.0
/usr/lib/frr/bgpd -d -A 0.0.0.0



# Aplicar configuración
vtysh -b

# Entrar a sesión interactiva
exec vtysh
