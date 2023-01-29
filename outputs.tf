# output "alb_all" {
# value = yandex_alb_load_balancer.example-balancer.*
#}




# 
# output "iALL" {
#   value = yandex_compute_instance.Server[*]
# }
output "ALL" {
  value = yandex_compute_instance.http[*]
}