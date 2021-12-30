
  provider "consul" {
        address    = "localhost:8500"
        datacenter = "dc1"
  }

resource "consul_keys" "networking" {
    key  {
        path ="networking/configuration/"
        value = ""
    }

    key  {
        path ="networking/state/"
        value = ""
    }
}

resource "consul_keys" "application"{
    key  {
        path ="application/configuration/"
        value = ""
    }

    key  {
        path ="application/state/"
        value = ""
    }
}

resource "consul_acl_policy" "networking" {
  name        = "networking"
  
  rules       = <<-RULE
    node_prefix "networking" {
      policy = "write"
    }
    session_prefix "" {
      policy = "write"
    }

    RULE
}

resource "consul_acl_policy" "application" {
  name        = "application"
  
  rules       = <<-RULE
    node_prefix "networking" {
      policy = "read"
    }
    node_prefix "application" {
      policy = "write"
    }
    session_prefix "" {
      policy = "write"
    }
    RULE
}

resource "consul_acl_token" "mary" {
  description = "token for Mary Moe"
  policies    = [consul_acl_policy.networking.name]
}

resource "consul_acl_token" "sally" {
  description = "token for Sally Sue"
  policies    = [consul_acl_policy.application.name]
}


output "mary_token_accessor_id" {
  value = consul_acl_token.mary.id
}

output "sally_token_accessor_id" {
  value = consul_acl_token.sally.id
}