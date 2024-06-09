#!/bin/bash

# Configuração do OpenDJ
/opt/opendj/setup \
    --cli \
    --baseDN "${BASE_DN}" \
    --rootUserDN "${ROOT_USER_DN}" \
    --rootUserPassword "${ROOT_PASSWORD}" \
    --ldapPort "${LDAP_PORT}" \
    --adminConnectorPort "${ADMIN_PORT}" \
    --jmxPort "${JMX_PORT}" \
    --hostname "${HOST_NAME}" \
    --enableStartTLS \
    --no-prompt \
    --acceptLicense

# Configuração do OpenAM
cd /usr/openam

/opt/openam/openam-configurator-tool/openam-configurator-tool \
    --acceptLicense \
    --serverUrl "https://${HOST_NAME}:${SERVER_PORT}/openam" \
    --adminPwd "${AMADMIN_PASSWORD}" \
    --baseDn "${BASE_DN}" \
    --cfgDir "/usr/openam/config" \
    --amEncKey "AQIC5wM2LY4Sfcyg9ThYI5xBt6tpxhzFD1P3dr0E" \
    --cookieDomain "${COOKIE_DOMAIN}" \
    --adminUser "uid=amAdmin,ou=People,${BASE_DN}" \
    --cfgStoreDirMgrPwd "${ROOT_PASSWORD}" \
    --cfgStoreRootSuffix "${BASE_DN}" \
    --cfgStoreDirHost "opendj" \
    --cfgStoreDirPort "${LDAP_PORT}" \
    --cfgStoreDirMgrDN "${ROOT_USER_DN}" \
    --cfgStoreDirJmxPort "${JMX_PORT}"
