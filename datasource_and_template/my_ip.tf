data "http" "my_ip" {
    url = "http://ifconfig.me"
}

output  "my_ip_addr"{
    value = data.http.my_ip.body
}


