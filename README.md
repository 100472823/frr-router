FRR Router – UC3M Labs (Adaptación Turris Omnia)

Este proyecto es una adaptación del entorno de prácticas de la UC3M basado en routers Turris Omnia con FRR. 
Históricamente, los Turris utilizaban FRRouting versión 7.5.1, pero para los laboratorios actuales se requiere 
una simulación del comportamiento de la versión 8.2. La diferencia entre ambas versiones es mínima para los 
protocolos usados en RYSCA y RIM (RIP, OSPF y BGP), por lo que la imagen Docker con FRR 7.5.1 reproduce de 
forma realista el mismo entorno que la versión 8.2.

---

OBJETIVO
--------
El objetivo es modernizar las prácticas de laboratorio sustituyendo los antiguos routers físicos por entornos 
contenedorizados con Docker. Esto permite a los alumnos y profesores trabajar con una infraestructura idéntica 
a la de los Turris Omnia pero de manera virtualizada y portátil.

La imagen Docker publicada incluye todos los demonios básicos activados: 
- zebra
- ripd
- ospfd
- bgpd

De este modo, cualquier escenario de enrutamiento avanzado se puede reproducir desde el CLI unificado de vtysh.

---

USO
---
Para ejecutar el contenedor basta con descargar la imagen desde Docker Hub:

    docker pull 100472823/frr-vtysh:latest

E iniciar con:

    docker run -it --name frr-vtysh --privileged --cap-add=NET_ADMIN 100472823/frr-vtysh:latest

Esto abrirá directamente la consola vtysh, idéntica a la del Turris Omnia.

---

USO CON DOCKER COMPOSE
----------------------
También se puede ejecutar mediante un archivo docker-compose.yml:

    services:
      frr-vtysh:
        image: 100472823/frr-vtysh:latest
        container_name: frr-vtysh
        privileged: true
        cap_add:
          - NET_ADMIN
        stdin_open: true
        tty: true

Con este archivo, basta ejecutar:

    docker compose up

---

MODIFICACIÓN DE LA CONFIGURACIÓN (frr.conf)
-------------------------------------------
El archivo principal de configuración se encuentra en /etc/frr/frr.conf dentro del contenedor.

Para modificarlo:
1. Entrar en la CLI de vtysh:

       docker exec -it frr-vtysh vtysh

2. Aplicar los cambios en caliente, por ejemplo:

       frr-router# config t
       frr-router(config)# router rip
       frr-router(config-router)# network 192.168.0.0/16

3. Guardar la configuración si se quiere persistir para futuros arranques, editando el archivo frr.conf 
   y adaptándolo a cada escenario.

Esto permite simular fácilmente distintos laboratorios y topologías de red sin necesidad de cambiar el 
software base ni rehacer la imagen. Simplemente con un nuevo frr.conf se consigue el “update” necesario 
para representar otro escenario.

---

CONCLUSIÓN
----------
Este proyecto proporciona una base estable para modernizar los laboratorios de redes de la UC3M, ofreciendo 
una experiencia equivalente a la de los Turris Omnia físicos, pero con mayor flexibilidad y facilidad de 
restauración. Al simular FRR 7.5.1 como equivalente práctico a FRR 8.2, los estudiantes pueden practicar 
con confianza protocolos de enrutamiento avanzados (RIP, OSPF, BGP) en un entorno seguro, replicable y 
completamente documentado.
