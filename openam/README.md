Configuração de OpenAM e OpenDJ com Docker
Estrutura do Projeto
project-root/
├── opendj/
│   ├── Dockerfile
│   └── config.ldif (se necessário)
├── openam/
│   ├── Dockerfile
│   └── certs/
│       ├── privkey.pem
│       ├── cert.pem
│       └── fullchain.pem
├── docker-compose.yml
└── .gitignore

Configuração
Dockerfile para OpenDJ
```Dockerfile
FROM openidentityplatform/opendj:latest

# Copiar arquivos de configuração necessários (se houver)
# COPY config.ldif /opt/opendj/config.ldif

# Adicionar script para inicializar a base DN
RUN echo '#!/bin/bash\n/opt/opendj/setup --cli -p 1389 -b "dc=openam,dc=openidentityplatform,dc=org" -h localhost --rootUserDN "cn=Directory Manager" --rootUserPassword password --enableStartTLS --doNotStart --acceptLicense\n/opt/opendj/bin/ldapmodify -a -h localhost -p 1389 -D "cn=Directory Manager" -w "password" <<EOF\ndn: dc=openam,dc=openidentityplatform,dc=org\nobjectClass: domain\ndc: openam\n\ndn: ou=people,dc=openam,dc=openidentityplatform,dc=org\nobjectClass: organizationalUnit\nou: people\n\ndn: ou=groups,dc=openam,dc=openidentityplatform,dc=org\nobjectClass: organizationalUnit\nou: groups\nEOF\n' > /opt/opendj/bootstrap/setup.sh

# Dar permissão para executar o script
RUN chmod +x /opt/opendj/bootstrap/setup.sh

# Executar o script durante a construção da imagem
RUN /opt/opendj/bootstrap/setup.sh

# Expor as portas necessárias
EXPOSE 1389 1636 4444

# Comando para iniciar o OpenDJ
CMD ["/opt/opendj/bin/start-ds"]
```

Dockerfile para OpenAM
```Dockerfile
FROM openidentityplatform/openam

# Criar diretório para os certificados com permissões de superusuário
USER root
RUN mkdir -p /etc/ssl/althora.com

# Copiar certificados do contexto de build para o contêiner
COPY certs/privkey.pem /etc/ssl/althora.com/privkey.pem
COPY certs/cert.pem /etc/ssl/althora.com/cert.pem
COPY certs/fullchain.pem /etc/ssl/althora.com/fullchain.pem

# Copiar server.xml para o Tomcat
COPY server.xml /usr/local/tomcat/conf/server.xml

# Expor a porta 8443
EXPOSE 8443

# Iniciar Tomcat
CMD ["catalina.sh", "run"]
```

docker-compose.yml
```yaml
version: '3.7'

services:
  opendj:
    build: ./opendj
    container_name: opendj
    ports:
      - "1389:1389"
      - "1636:1636"
      - "4444:4444"
    volumes:
      - opendj_data:/opt/opendj/data

  openam:
    build: ./openam
    container_name: openam
    ports:
      - "8080:8080"
      - "8443:8443"
    environment:
      - AMADMIN_PASSWORD=Ama53124!
      - DEBU=true
    volumes:
      - openam_data:/var/openam
    depends_on:
      - opendj

volumes:
  opendj_data:
  openam_data:
```

Instruções de Configuração
Passo 1: Clonar o Repositório
Clone este repositório em sua máquina local.

```bash
git clone git@github.com:Alvie40/Althora.git
cd Althora
```

Passo 2: Construir e Iniciar os Contêineres
Navegue até o diretório raiz do projeto onde o arquivo `docker-compose.yml` está localizado e execute os seguintes comandos:

```bash
sudo docker-compose up --build -d
```

Passo 3: Verificar os Logs
Verifique os logs para garantir que tudo está funcionando corretamente:

```bash
sudo docker-compose logs -f opendj
sudo docker-compose logs -f openam
```

Passo 4: Configurar o OpenAM
Acesse a interface web do OpenAM através do navegador em `https://<seu-dominio>:8443/openam` e siga os passos de configuração. Certifique-se de utilizar os detalhes corretos para o OpenDJ ao configurar o armazenamento de dados.

**Detalhes da Configuração do OpenDJ:**
- Host Name: `opendj`
- Port: `1389`
- Login ID: `cn=Directory Manager`
- Password: `password`
- Root Suffix: `dc=openam,dc=openidentityplatform,dc=org`

Resolução de Problemas
Se encontrar problemas, verifique os logs dos contêineres para identificar a causa:

```bash
sudo docker-compose logs -f opendj
sudo docker-compose logs -f openam
```

Limpeza
Para parar e remover os contêineres, execute:

```bash
sudo docker-compose down
```

Para remover todos os dados persistentes, remova os volumes Docker:

```bash
sudo docker-compose down -v
```

Contribuição
Sinta-se à vontade para abrir issues ou pull requests para melhorias ou correções.
Licença
Este projeto está licenciado sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.