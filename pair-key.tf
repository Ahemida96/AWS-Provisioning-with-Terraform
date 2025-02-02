resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = "terraform-key"
  public_key = tls_private_key.private_key.public_key_openssh
}

resource "local_file" "private_key" {
  filename        = "terraform-key.pem"
  content         = tls_private_key.private_key.private_key_pem
  file_permission = "0600"
}
