#!/bin/bash -x
set -aex

export VAULT_ADDR='http://127.0.0.1:8200'

vault secrets enable gcp

vault write gcp/config credentials=@vault-tester.json

cat > bindings.hcl<<EOF
  resource "//cloudresourcemanager.googleapis.com/projects/my-project-1234-285014" {
    roles = ["roles/viewer"]
  }
EOF

vault write gcp/static-account/my-key-account \
service_account_email="vault-tester@my-project-1234-285014.iam.gserviceaccount.com" \
secret_type="service_account_key"  \
bindings=@bindings.hcl


vault read gcp/static-account/my-key-account/key 
