# Визначаємо провайдера AWS та регіон. Ключі доступу передаємо через змінні.
provider "aws" {
  region     = "eu-north-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# Ресурс для створення ключа для підключення (SSH ключ)
resource "aws_key_pair" "lab_key" {
  key_name   = "keyforlab2"
  public_key = file(var.ssh_pub_key)    # наприклад, "~/.ssh/id_rsa.pub"
}

# Ресурс для створення Security Group, який дозволяє доступ по HTTP (порт 80) та SSH (порт 22)
resource "aws_security_group" "web_sg" {
  name        = "lab2"
  description = "Security group for web server"

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Ресурс для створення EC2 інстансу
resource "aws_instance" "web_instance" {
  ami           = var.ami            # Наприклад, використовуйте актуальний Ubuntu AMI
  instance_type = "t3.micro"
  key_name      = aws_key_pair.lab_key.key_name

  # Призначаємо security group
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # User data для автоматичного запуску Docker-образу вашого застосунку
  user_data = <<EOF
#!/bin/bash
# Оновлення системи
yum update -y

# Встановлення Docker
yum install -y docker

# Запуск Docker
systemctl start docker
systemctl enable docker

# Дозволити ec2-user запускати docker без sudo (опційно)
usermod -aG docker ec2-user

# Витягування та запуск контейнера
docker pull andriimytiev/mzuiit-lab2:latest
docker run -d -p 80:80 andriimytiev/mzuiit-lab2:latest

# Запуск Watchtower з --cleanup
docker run -d --name watchtower -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --interval 30 --cleanup
EOF
}

