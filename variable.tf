variable "vm_all" {
  description = "list of the names  VM all"
  type        = list(string)
  default     = [ "prometheus11", "http22"]

  #default     = [ "prometheus11", "grafana11", "sg11", "elastic11", "kibana11","http22", "http11"]
}

variable "vm_http" {
  description = "list of the names  http "
  type        = list(string)
 # default     = ["http22"]
   default     = ["http22", "http11"]

}

variable "vm_names" {
  description = "list of the names  VM "
  type        = list(string)
  default     = [ "prometheus11","grafana11","http11"]
 # default     = ["http22" ,"http11", "prometheus11", "grafana11", "sg11", "elastic11", "kibana11"]
}

variable "port_sg_egress" {
    default    = {
 #   "sg11"     = ["22"]
    "grafana11"= ["9090"]
    "prometheus11" = ["22","9090","9093","4040"]
  #  "http22" = ["9100","4040","5044"]
    "http11" = ["9100","4040","5055"]
  #  "elastic11" = ["5055","5044", "9200"]
  #  "kibana11" = ["5601","9200"]
    }
}
variable "port_sg_ingress" {
    default    = {
 #   "sg11"     = ["22"]
    "grafana11"= ["22", "3000"]
    "prometheus11" = ["22", "9090", "9100", "5001","4040"]
 #   "http22" = ["22","80","9100","4040","5044"]
    "http11" = ["22","80","9100","4040","5055"]
  #  "elastic11" = ["22","5055","5044", "9200"]
  #  "kibana11" = ["22","5601","9200"]
    }

}