resource "aws_ecs_cluster" "this" {
    name = "strapi-cluster"
}

resource "aws_ecs_task_definition" "this" {
    family                   = "strapi-task"
    network_mode             = "bridge"
    requires_compatibilities = ["EC2"]
    cpu                      = "512"
    memory                   = "1024"

    container_definitions = jsonencode([
        {
        name      = "strapi"
        image     = var.image_uri
        essential = true

        portMappings = [{
            containerPort = 1337
            hostPort      = 1337
        }]
        }
    ])
}

resource "aws_ecs_service" "this" {
    name            = "strapi-service"
    cluster         = aws_ecs_cluster.this.id
    task_definition = aws_ecs_task_definition.this.arn
    desired_count   = 1
    launch_type     = "EC2"
}

resource "aws_iam_role" "ecs_instance_role" {
    name = "ecsInstanceRole"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
            Service = "ec2.amazonaws.com"
        }
        }]
    })
}

resource "aws_iam_role_policy_attachment" "ecs_instance_policy" {
    role       = aws_iam_role.ecs_instance_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs" {
    name = "ecsInstanceProfile"
    role = aws_iam_role.ecs_instance_role.name
}

resource "aws_security_group" "ecs" {
    name   = "ecs-strapi-sg"
    vpc_id = data.aws_vpc.default.id

    ingress {
        from_port   = 1337
        to_port     = 1337
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "ecs" {
    ami           = data.aws_ami.ecs.id
    instance_type = "t3.small"
    subnet_id     = data.aws_subnets.default.ids[0]
    
    vpc_security_group_ids = [aws_security_group.ecs.id]

    iam_instance_profile = aws_iam_instance_profile.ecs.name

    user_data = <<EOF
        #!/bin/bash
        echo ECS_CLUSTER=${aws_ecs_cluster.this.name} >> /etc/ecs/ecs.config
        EOF
}
