#!/bin/bash

# Executar a configuração do OpenDJ
/opt/opendj/setup --cli --adminConnectorPort 4444 --baseDN dc=openam,dc=openidentityplatform,dc=org --rootUserDN cn=Directory\ Manager --ldapPort 1389 --skipPortCheck --rootUserPassword password --jmxPort 1689 --no-prompt --doNotStart --hostname opendj
