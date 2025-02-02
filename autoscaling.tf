resource "aws_launch_configuration" "ec2-config" {
  name          = "terraform-launch-configuration"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  security_groups = [
    aws_security_group.ec2-sg.id
  ]
  key_name = var.key_name
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

# module "asg" {
#   source = "terraform-aws-modules/autoscaling/aws"

#   # Autoscaling group
#   name = "terraform-asg"

#   min_size                  = 1
#   max_size                  = 2
#   desired_capacity          = 1
#   wait_for_capacity_timeout = 0
#   health_check_type         = "EC2"
#   vpc_zone_identifier       = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id]

#   initial_lifecycle_hooks = [
#     {
#       name                  = "StartupLifeCycleHook"
#       default_result        = "CONTINUE"
#       heartbeat_timeout     = 60
#       lifecycle_transition  = "autoscaling:EC2_INSTANCE_LAUNCHING"
#       notification_metadata = jsonencode({ "hello" = "world" })
#     },
#     {
#       name                  = "TerminationLifeCycleHook"
#       default_result        = "CONTINUE"
#       heartbeat_timeout     = 180
#       lifecycle_transition  = "autoscaling:EC2_INSTANCE_TERMINATING"
#       notification_metadata = jsonencode({ "goodbye" = "world" })
#     }
#   ]

#   instance_refresh = {
#     strategy = "Rolling"
#     preferences = {
#       checkpoint_delay       = 600
#       checkpoint_percentages = [35, 70, 100]
#       instance_warmup        = 300
#       min_healthy_percentage = 50
#       max_healthy_percentage = 100
#     }
#     triggers = ["tag"]
#   }

#   # Launch template
#   launch_template_name        = "terraform-launch-template"
#   launch_template_description = "Launch template example"
#   update_default_version      = true

#   image_id          = data.aws_ami.ubuntu.id
#   instance_type     = var.instance_type
#   ebs_optimized     = true
#   enable_monitoring = true

#   # IAM role & instance profile
#   create_iam_instance_profile = true
#   iam_role_name               = "terraform-iam-role"
#   iam_role_path               = "/"
#   iam_role_description        = "IAM role for EC2 instances"
#   iam_role_tags = {
#     CustomIamRole = "Yes"
#   }
#   iam_role_policies = {
#     AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
#   }

#   block_device_mappings = [
#     {
#       # Root volume
#       device_name = "/dev/xvda"
#       no_device   = 0
#       ebs = {
#         delete_on_termination = true
#         encrypted             = true
#         volume_size           = 20
#         volume_type           = "gp2"
#       }
#       }, {
#       device_name = "/dev/sda1"
#       no_device   = 1
#       ebs = {
#         delete_on_termination = true
#         encrypted             = true
#         volume_size           = 30
#         volume_type           = "gp2"
#       }
#     }
#   ]

#   capacity_reservation_specification = {
#     capacity_reservation_preference = "open"
#   }

#   cpu_options = {
#     core_count       = 1
#     threads_per_core = 1
#   }

#   credit_specification = {
#     cpu_credits = "standard"
#   }

#   instance_market_options = {
#     market_type = "spot"
#     spot_options = {
#       block_duration_minutes = 60
#     }
#   }

#   # This will ensure imdsv2 is enabled, required, and a single hop which is aws security
#   # best practices
#   # See https://docs.aws.amazon.com/securityhub/latest/userguide/autoscaling-controls.html#autoscaling-4
#   metadata_options = {
#     http_endpoint               = "enabled"
#     http_tokens                 = "required"
#     http_put_response_hop_limit = 1
#   }

#   network_interfaces = [
#     {
#       delete_on_termination = true
#       description           = "eth0"
#       device_index          = 0
#       security_groups       = ["sg-12345678"]
#     },
#     {
#       delete_on_termination = true
#       description           = "eth1"
#       device_index          = 1
#       security_groups       = ["sg-12345678"]
#     }
#   ]

#   placement = {
#     availability_zone = "us-west-1a"
#   }

#   tag_specifications = [
#     {
#       resource_type = "instance"
#       tags          = { WhatAmI = "Instance" }
#     },
#     {
#       resource_type = "volume"
#       tags          = { WhatAmI = "Volume" }
#     },
#     {
#       resource_type = "spot-instances-request"
#       tags          = { WhatAmI = "SpotInstanceRequest" }
#     }
#   ]

#   tags = {
#     Environment = "dev"
#     Project     = "megasecret"
#   }
# }
