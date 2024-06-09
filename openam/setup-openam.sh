#!/bin/bash

# Verificar se os certificados estão presentes
if [ ! -f /etc/ssl/althora.com/privkey.pem ] || [ ! -f /etc/ssl/althora.com/cert.pem ] || [ ! -f /etc/ssl/althora.com/fullchain.pem ]; then
    echo "Certificados SSL não encontrados. Certifique-se de que privkey.pem, cert.pem e fullchain.pem estão presentes em /etc/ssl/althora.com/"
    exit 1
fi

# Copiar certificados para o Tomcat
cp /etc/ssl/althora.com/* /usr/local/tomcat/conf/

# Executar a configuração do OpenAM
/opt/openam/configurator-tool/bin/openam-configurator-tool --acceptLicense --configFile /usr/openam/bootstrap/openam-configurator-setup.txt

# Reiniciar o Tomcat para garantir que as configurações sejam aplicadas
catalina.sh stop
sleep 10
catalina.sh start
