#!/bin/sh
# Create password salt for graylog
GRAYLOG_PASSWORD_SECRET_B64=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1 | base64 -w0 )

# Create graylog admin password
GRAYLOG_ADMIN_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1 )
GRAYLOG_ADMIN_PASSWORD_B64=$( echo -n $GRAYLOG_ADMIN_PASSWORD | base64 -w0 )

GRAYLOG_PASSWORD_SHA_B64=$(echo $GRAYLOG_ADMIN_PASSWORD | tr -d '\n' | sha256sum | cut -d" " -f1 | base64 -w0)
 
# Create mongodb password
MONGODB_PASSWORD_B64=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1 | base64 -w0)

cat << EOF > secrets.yaml
apiVersion: v1
data:
  graylog.password.secret: ${GRAYLOG_PASSWORD_SECRET_B64}
  graylog.root.password.sha2: ${GRAYLOG_PASSWORD_SHA_B64}
  graylog.admin.password: ${GRAYLOG_ADMIN_PASSWORD_B64}
  graylog.mongodb.password: ${MONGODB_PASSWORD_B64}
kind: Secret
metadata:
  name: graylog
  namespace: graylog
type: Opaque
EOF

echo "Graylog Admin Password: $GRAYLOG_ADMIN_PASSWORD"
