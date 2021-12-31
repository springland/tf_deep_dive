export CONSUL_HTTP_TOKEN=06583687-157a-6599-b63e-d6413110ef13

cd config
consul kv put  networking/configuration/globo-primary/common-tags @common-tags.json
consul kv put  networking/configuration/globo-primary/net-info @globo-primary.json

cd networking
terraform init -backend-config="path=networking/state/globo-primary"

networking2
consul kv put networking/configuration/globo-primary/net-info @globo-primary2.json
cd networking2
terraform init -backend-config="path=networking/state/globo-primary"