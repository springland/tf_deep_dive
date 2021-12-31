Use dev/uat/prod workspaces
each env is a sub directory on consul server

Networking team uses Mary Moe's token


Application team uses Sally Sue's token



Please check out manage_state_remote for how to get the tokens

Application team can read networking state to get subnet information. This is a collaboration example


Consul
consul acl bootstrap
export CONSUL_HTTP_TOKEN=ac65948c-0f97-c622-36a0-4f40e2fc7cba


mary_token_accessor_id = "9d816fb8-2990-0fa8-891d-ede5630e1df1"
sally_token_accessor_id = "916c0d32-231a-b770-0750-08e51baaed2c"

Networking

Get Mary Moe's token
consul acl  token read -id 9d816fb8-2990-0fa8-891d-ede5630e1df1

export CONSUL_HTTP_TOKEN=a74294db-39ee-76e9-0ee9-2c234bbbd68d
cd networking/config
consul kv put  networking/configuration/globo-primary/common-tags @net-tags.json
consul kv put  networking/configuration/globo-primary/dev/net-info @dev-net.json
consul kv put  networking/configuration/globo-primary/uat/net-info @uat-net.json
consul kv put  networking/configuration/globo-primary/prod/net-info @prod-net.json

cd ..

tf init -backend-config="path=networking/state/globo-primary"
tf workspace new dev
tf apply


Application

Get Sally Sue's token
consul acl  token read -id 916c0d32-231a-b770-0750-08e51baaed2c
export CONSUL_HTTP_TOKEN=9cb1c8d1-8e1e-cb0f-7e55-a9146751b914

consul kv put  application/configuration/globo-primary/common-tags @app-tags.json
consul kv put  application/configuration/globo-primary/dev/app-info @dev-app.json
consul kv put  application/configuration/globo-primary/uat/app-info @uat-app.json
consul kv put  application/configuration/globo-primary/prod/app-info @prod-app.json

tf init -backend-config="path=application/state/globo-primary"
tf workspace new dev