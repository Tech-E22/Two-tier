data "aws_ami" "linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  owners = ["amazon"]
}

resource "aws_launch_template" "wk21_bastion" {
  name_prefix            = "wk21_bastion"
  image_id               = data.aws_ami.linux.id
  instance_type          = var.bastion_instance_type
  vpc_security_group_ids = [var.public_sg]

  tags = {
    Name = "wk21_bastion"
  }
}

resource "aws_autoscaling_group" "wk21_bastion" {
  name                = "wk21_bastion"
  vpc_zone_identifier = tolist(var.public_subnet)
  min_size            = 1
  max_size            = 1
  desired_capacity    = 1

  launch_template {
    id      = aws_launch_template.wk21_bastion.id
    version = "$Latest"
  }
}

resource "aws_launch_template" "wk21_database" {
  name_prefix            = "wk21_database"
  image_id               = data.aws_ami.linux.id
  instance_type          = var.database_instance_type
  vpc_security_group_ids = [var.private_sg]
  user_data              = filebase64("bootstrap.sh")

  tags = {
    Name = "wk21_database"
  }
}

resource "aws_autoscaling_group" "wk21_database" {
  name                = "wk21_database"
  vpc_zone_identifier = tolist(var.public_subnet)
  min_size            = 2
  max_size            = 3
  desired_capacity    = 2

  launch_template {
    id      = aws_launch_template.wk21_database.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.wk21_database.id
  alb_target_group_arn = var.alb_tg
}