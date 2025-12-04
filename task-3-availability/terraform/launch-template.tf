resource "aws_launch_template" "web" {
  name_prefix   = "${var.prefix}_LaunchTemplate_"
  image_id      = data.aws_ami.amazon_linux_2023.id
  instance_type = "t2.micro"
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.asg_instances.id]

  monitoring {
    enabled = true
  }

  user_data = base64encode(file("${path.module}/user-data.sh"))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.prefix}_ASG_Instance"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}