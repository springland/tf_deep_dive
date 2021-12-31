1. working with existing resources
2. managing resources remotely
3. data source and template
5. workspace_and_collaboration


**Can only call consul acl bootstrap once after it started , if it is called second time it returns 
Failed ACL bootstrapping: Unexpected response code: 403 (Permission denied: ACL bootstrap no longer allowed (reset index: 16))   even with  CONSUL_HTTP_TOKEN being updated**


Each time the tokens are delete from consul after reboot ( expected ? consul is a directory service , in theory the service can re-register to consul , need to study more)



