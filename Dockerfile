# una imagen de un agente JNLP para Jenkins con Powershell Core instalado
FROM ubuntu:jammy

ENTRYPOINT ["java", "-jar", "/var/jenkins_home/agent.jar"]

RUN apt update && \
    apt install -y openssh-server openjdk-17-jre-headless git wget

# instalar Powershell Core con un script
WORKDIR /root
COPY ./script-instalacion-pwsh.sh .
RUN chmod u+x script-instalacion-pwsh.sh && sh -c ./script-instalacion-pwsh.sh 
RUN rm script-instalacion-pwsh.sh

# script de Powershell para instalar ImportExcel
COPY script-instalacion-modulos.ps1 .
RUN pwsh -NonInteractive -c ./script-instalacion-modulos.ps1

# crear el usuario Jenkins con contraseña jenkins
RUN useradd -m -d /var/jenkins_home -s /bin/bash jenkins
RUN echo 'jenkins:jenkins' | chpasswd

WORKDIR /var/jenkins_home
USER jenkins

# el ejecutable agent.jar que da a este contenedor las capacidades de Jenkins
COPY agent.jar ./agent.jar