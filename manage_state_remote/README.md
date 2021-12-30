There are multiple teams , create infrastructure for other teams , collaborate with each other
manage terraform state on remote server
restrict access for other teams


Consul supports access control


## Setup terraform on  local ##

tf init
tf apply

## Setup Consul
docker run consul

docker run -d --name test-consul -p 8500:8500 --mount type=bind,source=/data/consul/data,target=/consul/data  --mount type=bind,source=/data/consul/config,target=/consul/config consul

get token 
consul acl bootstrap
SecretID:         06583687-157a-6599-b63e-d6413110ef13
export CONSUL_HTTP_TOKEN=06583687-157a-6599-b63e-d6413110ef13

cd  consul
tf apply 

mary_token_accessor_id = "deb458f7-3ffb-99c1-2422-14996f048731"
sally_token_accessor_id = "461f7f84-516b-ed48-55f3-e9ea430ba822"

consul acl  token read -id deb458f7-3ffb-99c1-2422-14996f048731
SecretID:         982081ec-2289-8011-c751-fd8e2faef1b0
Description:      token for Mary Moe

consul acl  token read -id 461f7f84-516b-ed48-55f3-e9ea430ba822
SecretID:         dc4e479c-4645-a473-7bd2-25a8a2390ec9
Description:      token for Sally Sue
## migrate to consul

copy backend.tf to parent
change to mary's token
export CONSUL_HTTP_TOKEN=982081ec-2289-8011-c751-fd8e2faef1b0
tf init --backend-config="path=networking/state"
tf apply



