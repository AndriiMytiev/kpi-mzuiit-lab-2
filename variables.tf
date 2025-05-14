variable "aws_access_key" {
  description = "AWS IAM Access Key для створення інстансів"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS IAM Secret Key для створення інстансів"
  type        = string
}

variable "ssh_pub_key" {
  description = "Шлях до файлу з публічним SSH ключем, який використовується для підключення"
  type        = string
  default     = "./id_rsa.pub"
}

variable "ami" {
  description = "AMI для запуску EC2 інстансу. Вкажіть правильний AMI-ідентифікатор для обраного регіону."
  type        = string
}

