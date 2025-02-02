resource "aws_launch_configuration" "ec2-config" {
  name          = "terraform-launch-configuration"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  security_groups = [
    aws_security_group.ec2-sg.id
  ]
  key_name = aws_key_pair.key_pair.key_name
  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo yum install -y httpd
                sudo systemctl start httpd
                sudo systemctl enable httpd
                echo "Hello World from $(hostname -I)" > /var/www/html/index.html
                EOF
  # Add the following provisioner block to the aws_launch_configuration resource to install the httpd package on the EC2 instances:
  /*
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
  ]
  */

  # Add the following provisioner block to the aws_launch_configuration resource to copy the index.html file to the EC2 instances:
  provisioner "file" {
    source      = "index.html"
    destination = "/var/www/html/index.html"
  }

}

resource "aws_autoscaling_group" "asg" {
  name                      = "terraform-asg"
  launch_configuration      = aws_launch_configuration.ec2-config.name
  min_size                  = 2
  max_size                  = 4
  desired_capacity          = 2
  vpc_zone_identifier       = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id]
  health_check_type         = "EC2"
  wait_for_capacity_timeout = 0
  target_group_arns         = [aws_lb_target_group.target-group.arn]
  tag {
    key                 = "Name"
    value               = "terraform-asg"
    propagate_at_launch = true
  }
  tag {
    key                 = "Environment"
    value               = "dev"
    propagate_at_launch = true
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "asg-policy-down" {
  name                   = "terraform-asg-policy-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

resource "aws_autoscaling_policy" "asg-policy-up" {
  name                   = "terraform-asg-policy-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

