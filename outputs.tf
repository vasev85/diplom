

# output "alb_all" {
# value = yandex_alb_load_balancer.example-balancer.*
#}





output "iALL" {
  value = yandex_compute_instance.Server[*]
}


output "Zhost" {
  value = yandex_compute_instance.Server[*].network_interface.0.nat_ip_address
}



