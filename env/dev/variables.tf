variable "ssh_ip" {
  description = "SSH ホストのグローバルIP"
  type        = list(string)
  sensitive   = true
}
