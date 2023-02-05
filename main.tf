terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}
   





# http-server
# resource "yandex_compute_instance" "http"  {
#     count = length(var.vm_http)
#     name = var.vm_http[count.index]
#     platform_id = "standard-v3"
#     zone = var.vm_http[count.index] == "http22" ? "ru-central1-a" :  "ru-central1-b" 
#     hostname = "${var.vm_http[count.index]}.dip."
# 
# 
# 
# #Прерываяемая ВМ
# scheduling_policy {
#     preemptible = true
#   }
# 
#   resources {
#     cores  = 2
#     memory = 2
#     core_fraction = 20
#   }
# 
#   boot_disk {
#     initialize_params {
#       #size = 4194304 
#       image_id = "fd8qc4ui9j0elhh8im0n"
#     }
#   }
# 
#   network_interface {
#     #subnet_id = "yandex_vpc_subnet.dip-ru-central1-a11.id" 
#    subnet_id = var.vm_http[count.index] == "http22"  ? yandex_vpc_subnet.dip-ru-central1-a11.id : yandex_vpc_subnet.dip-ru-central1-b11.id
#   dns_record {
#     fqdn = "${var.vm_http[count.index]}.dip."
#     ttl = 300
#   }
#     nat       = true
#   }
#   
# 
# 
# metadata = {
#     user-data = "${file("./nginx-meta.yml")}" 
#   }
# }  





resource "yandex_compute_instance" "Server"  {
    count = length(var.vm_names)
    name = var.vm_names[count.index]
    platform_id = "standard-v3"
    zone = var.vm_names[count.index] == "prometheus11" || var.vm_names[count.index] == "http22" ? "ru-central1-a" :  "ru-central1-b" 
    hostname = "${var.vm_names[count.index]}.dip."
#Прерываяемая ВМ
scheduling_policy {
    preemptible = true
  }
  resources {
    cores  = 2
    memory = var.vm_names[count.index] == "elastic11" || var.vm_names[count.index] ==  "kibana11" ?  8 : 2 
    core_fraction = 20
  }
  boot_disk {
    initialize_params {
      #size = 4194304 
      image_id = "fd8qc4ui9j0elhh8im0n"
    }
  }
  network_interface {
    #subnet_id = "yandex_vpc_subnet.dip-ru-central1-a11.id" 
   subnet_id = var.vm_names[count.index] == "prometheus11" || var.vm_names[count.index] == "http22"  ? yandex_vpc_subnet.dip-ru-central1-a11.id : yandex_vpc_subnet.dip-ru-central1-b11.id
  dns_record {
    fqdn = "${var.vm_names[count.index]}.dip."
    ttl = 300
  }
    nat       = true
   # security_group_ids = [yandex_vpc_security_group.sg[count.index].id]
        
      
  }
metadata = {
  
    
    
     
          user-data =  "${file("./${var.vm_names[count.index]}-meta.yml")}"
     
     
   
   # user-data = var.vm_names[count.index] == "grafana11" ? "${file("./grafana-meta.yml")}" : ""
  #  user-data = var.vm_names[count.index] == "prometheus11" ? "${file("./prometheus-meta.yml")}" : ""
}
}  



resource "yandex_vpc_network" "dip111" {
   name = "dip111"
}

resource "yandex_vpc_subnet" "dip-ru-central1-b11" {
  name           = "dip-ru-central1-b11"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.dip111.id
  v4_cidr_blocks = ["10.129.129.0/24"]
}

resource "yandex_vpc_subnet" "dip-ru-central1-a11" {
  name           = "dip-ru-central1-a11"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.dip111.id
  v4_cidr_blocks = ["10.128.128.0/24"]
}


resource "yandex_vpc_security_group" "sg" {
    count = length(var.vm_names)
    name = var.vm_names[count.index]
    network_id = yandex_vpc_network.dip111.id


  dynamic  "egress" {
    for_each = lookup (var.port_sg_egress, var.vm_names[count.index])
    content {
        protocol       = "TCP"
        port           = egress.value
        v4_cidr_blocks = ["10.0.0.0/8"]
       
    }
  } 
 
  dynamic  "ingress" {
    for_each = lookup (var.port_sg_ingress, var.vm_names[count.index])
    content {
        protocol       = "TCP"
        port           = ingress.value
        v4_cidr_blocks = ["0.0.0.0/0"]
       
    }
  }  
 
}



#---------------------------------------------alb-----------------------------------
# # Target group
# resource "yandex_alb_target_group" "diplom" {
#   name           = "tg-web111"
#   
#   dynamic "target" {
#      for_each = yandex_compute_instance.http[*].network_interface.0.subnet_id
#      content {
#          subnet_id    = yandex_compute_instance.http[target.key].network_interface.0.subnet_id
#          ip_address   = yandex_compute_instance.http[target.key].network_interface.0.ip_address
#           }
#  }
# # target {
# # count = length(var.vm_http)
# # target {
# #     subnet_id    = yandex_compute_instance.Server[1].network_interface.0.subnet_id
# #     ip_address   = yandex_compute_instance.Server[1].network_interface.0.ip_address
# #   }
# }
# # Backend group for L7 balancer
# resource "yandex_alb_backend_group" "dip-backend-group" {
#   name                     = "back11"
# 
#   http_backend {
#     name                   = "back11"
#     weight                 = 1
#     port                   = 80
#     target_group_ids       = ["${yandex_alb_target_group.diplom.id}"]
#     load_balancing_config {
#       panic_threshold      = 3
#     }    
#     healthcheck {
#       timeout              = "1s"
#       interval             = "1s"
#       healthy_threshold    = 2
#       unhealthy_threshold  = 15 
#       http_healthcheck {
#         path               = "/"
#       }
#     }
#   }
# }
# 
# 
# # Роутер для L7 balancer
# resource "yandex_alb_http_router" "diplomrouter" {
#   name = "diplomrouter"
# }
# 
# resource "yandex_alb_virtual_host" "diplomvh" {
#   name           = "diplomvh"
#   http_router_id = yandex_alb_http_router.diplomrouter.id
#   #authority      = "cdn.yandexcloud.example"
#   #authority      =  ["http11.dip."]
# 
#   route {
#     name = "main-route"
#     http_route {
#       http_route_action {
#         backend_group_id = yandex_alb_backend_group.dip-backend-group.id
#         timeout          = "3s"
#       }
#     }
#   
#   
#   }  
# }
#   #L7  balancer
# resource "yandex_alb_load_balancer" "example-balancer" {
#   name               = "example-balancer"
#   network_id         = yandex_vpc_network.dip111.id
#   
# 
#   allocation_policy {
#     location {
#       zone_id   = "ru-central1-a"
#       subnet_id = yandex_vpc_subnet.dip-ru-central1-a11.id
#     }
# 
#     location {
#       zone_id   = "ru-central1-b"
#       subnet_id = yandex_vpc_subnet.dip-ru-central1-b11.id
#     }
# 
#     
#   }
# 
#   listener {
#     name = "example-listener"
#     endpoint {
#       address {
#         external_ipv4_address {
#         }
#       }
#       ports = [80]
#     }
#     http {
#       handler {
#         http_router_id = yandex_alb_http_router.diplomrouter.id 
#       }
#     }
#   }
# }






