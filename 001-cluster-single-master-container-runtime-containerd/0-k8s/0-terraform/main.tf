provider "aws" {
  region = "us-east-1"
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com" # outra opção "https://ifconfig.me"
}

resource "aws_instance" "maquina_master" {
  ami           = "ami-09e67e426f25ce0d7"
  instance_type = "t2.large"
  key_name      = "chave_publica_desafio_kubernetes"
  # subnet_id = "subnet-08645deaef16c66a5"
  associate_public_ip_address = true
  tags = {
    Name = "k8s-master_com_containerd"
  }
  root_block_device {
    delete_on_termination = true
    encrypted             = false
    volume_size           = 32
  }
  vpc_security_group_ids = [aws_security_group.acessos_master.id]
  depends_on = [
    aws_instance.workers,
  ]
}

resource "aws_instance" "workers" {
  ami           = "ami-09e67e426f25ce0d7"
  instance_type = "t2.medium"
  key_name      = "chave_publica_desafio_kubernetes"
  # subnet_id = "subnet-0623015d80441b535"
  associate_public_ip_address = true
  tags = {
    Name = "k8s-node_com_containerd-${count.index + 1}"
  }
  root_block_device {
    delete_on_termination = true
    encrypted             = false
    volume_size           = 32
  }
  vpc_security_group_ids = [aws_security_group.acessos_workers.id]
  count         = 2
}

resource "aws_security_group" "acessos_master" {
  name        = "acessos_master_com_containerd"
  description = "acessos_master inbound traffic"
  vpc_id = "vpc-f0d19897"

  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["${chomp(data.http.myip.body)}/32"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = null,
      security_groups: null,
      self: null
    },
    {
      description      = "Liberando app nodejs para o mundo"
      from_port        = 30000
      to_port          = 30000
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = null,
      security_groups: null,
      self: null
    }
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"],
      prefix_list_ids = null,
      security_groups: null,
      self: null,
      description: "Libera dados da rede interna"
    }
  ]

  tags = {
    Name = "acessos_master"
  }
}


resource "aws_security_group" "acessos_workers" {
  name        = "acessos_workers_com_containerd"
  description = "acessos_workers inbound traffic"
  vpc_id = "vpc-f0d19897"

  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["${chomp(data.http.myip.body)}/32"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = null,
      security_groups: null,
      self: null
    }
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"],
      prefix_list_ids = null,
      security_groups: null,
      self: null,
      description: "Libera dados da rede interna"
    }
  ]

  tags = {
    Name = "acessos_workers"
  }
}


# terraform refresh para mostrar o ssh
output "maquina_master" {
  value = [
    "master - ${aws_instance.maquina_master.public_ip}",
  ]
}

# terraform refresh para mostrar o ssh
output "maquina_workers" {
  value = [
    for key, item in aws_instance.workers :
      "worker ${key+1} - ${item.public_ip}"
  ]
}