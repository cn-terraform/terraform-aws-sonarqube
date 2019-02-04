# ---------------------------------------------------------------------------------------------------------------------
# AWS Cloudwatch
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "sonar_log_group" {
    name              = "${local.sonar_cloudwatch_log_path}"
    retention_in_days = "7"
    tags {
        Name = "${local.sonar_cloudwatch_log_path}"
    }
}
resource "aws_cloudwatch_log_stream" "sonar_log_stream" {
  name           = "${local.sonar_cloudwatch_log_path}"
  log_group_name = "${aws_cloudwatch_log_group.sonar_log_group.name}"
}

# ---------------------------------------------------------------------------------------------------------------------
# ECS Task Definition
# ---------------------------------------------------------------------------------------------------------------------
# Task Definition Template
data "template_file" "sonar_td_template" {
    template = "${file("${path.module}/files/tasks_definitions/sonar_task_definition.json")}"
    vars {
        NAME                       = "${local.sonar_container_name}"
        DOCKER_IMAGE_NAME          = "sonarqube"
        DOCKER_IMAGE_TAG           = "7.6-community"
        CPU                        = "${local.sonar_fargate_cpu_value}"
        MEMORY                     = "${local.sonar_fargate_memory_value}"
        CLOUDWATCH_PATH            = "${local.sonar_cloudwatch_log_path}"
        AWS_REGION                 = "${var.region}"
        SONAR_CONTAINER_WEB_PORT   = "${local.sonar_container_web_port}"
        SONAR_JDBC_USERNAME        = "${local.sonar_db_username}"
        SONAR_JDBC_PASSWORD        = "${local.sonar_db_password}"
        SONAR_JDBC_URL             = "jdbc:postgresql://${aws_rds_cluster.aurora_db.endpoint}/${local.sonar_db_name}"
    }
}
# Task Definition
resource "aws_ecs_task_definition" "sonar_td" {
    depends_on               = [ "aws_rds_cluster.aurora_db", "aws_rds_cluster_instance.aurora_db_cluster_instances" ]
    family                   = "${var.name_preffix}-sonar"
    container_definitions    = "${data.template_file.sonar_td_template.rendered}"
    requires_compatibilities = [ "FARGATE" ]
    network_mode             = "awsvpc"
    cpu                      = "${local.sonar_fargate_cpu_value}"
    memory                   = "${local.sonar_fargate_memory_value}"
    execution_role_arn       = "${aws_iam_role.ecs_task_execution_role.arn}"
    task_role_arn            = "${aws_iam_role.ecs_task_execution_role.arn}"
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS ECS Service
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_ecs_service" "sonar_service" {
    name            = "${var.name_preffix}-sonar"
    depends_on      = [ "aws_alb_listener.sonar_web_listener" ]
    cluster         = "${aws_ecs_cluster.sonar_cluster.id}"
    task_definition = "${aws_ecs_task_definition.sonar_td.arn}"
    launch_type     = "FARGATE"
    desired_count   = 1
    network_configuration {
        security_groups  = [ "${aws_security_group.ecs_tasks_sg.id}" ]
        subnets          = [ "${var.private_subnets_ids}" ]
        assign_public_ip = true
    }
    load_balancer {
        target_group_arn = "${aws_alb_target_group.sonar_alb_tg.arn}"
        container_name   = "${local.sonar_container_name}"
        container_port   = "${local.sonar_container_web_port}"
    }
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS ALB
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_alb" "sonar_alb" {
    name            = "${var.name_preffix}-sonar-alb"
    internal        = false
    subnets         = ["${var.public_subnets_ids}"]
    security_groups = ["${aws_security_group.alb_sg.id}"]
    tags {
        Name = "${var.name_preffix}-sonar-alb"
    } 
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS ALB Target Group
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_alb_target_group" "sonar_alb_tg" {
    depends_on  = [ "aws_alb.sonar_alb" ]
    name        = "${var.name_preffix}-sonar-alb-tg"
    protocol    = "HTTP"
    port        = "${local.sonar_container_web_port}"
    vpc_id      = "${var.vpc_id}"
    target_type = "ip"
    health_check = {
        path = "/"
        port = "${local.sonar_container_web_port}"
    }
    tags {
        Name = "${var.name_preffix}-sonar-alb-tg"
    } 
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS ALB Listener
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_alb_listener" "sonar_web_listener" {
    load_balancer_arn = "${aws_alb.sonar_alb.arn}"
    port              = "80"
    protocol          = "HTTP"
    default_action {
        target_group_arn = "${aws_alb_target_group.sonar_alb_tg.arn}"
        type = "forward"
    }
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS Auto Scaling
# ---------------------------------------------------------------------------------------------------------------------
# CloudWatch Alarm CPU High
resource "aws_cloudwatch_metric_alarm" "sonar_cpu_high" {
    alarm_name          = "${var.name_preffix}-sonar-cpu-high"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = "3"
    metric_name         = "CPUUtilization"
    namespace           = "AWS/ECS"
    period              = "60"
    statistic           = "Maximum"
    threshold           = "85"
    dimensions {
        ClusterName = "${aws_ecs_cluster.sonar_cluster.name}"
        ServiceName = "${aws_ecs_service.sonar_service.name}"
    }
    alarm_actions = [ "${aws_appautoscaling_policy.sonar_scale_up_policy.arn}" ]
}
# CloudWatch Alarm CPU Low
resource "aws_cloudwatch_metric_alarm" "sonar_cpu_low" {
    alarm_name          = "${var.name_preffix}-sonar-cpu-low"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods  = "3"
    metric_name         = "CPUUtilization"
    namespace           = "AWS/ECS"
    period              = "60"
    statistic           = "Average"
    threshold           = "10"
    dimensions {
        ClusterName = "${aws_ecs_cluster.sonar_cluster.name}"
        ServiceName = "${aws_ecs_service.sonar_service.name}"
    }
    alarm_actions = [ "${aws_appautoscaling_policy.sonar_scale_down_policy.arn}" ]
}
# Scaling Up Policy
resource "aws_appautoscaling_policy" "sonar_scale_up_policy" {
    name                    = "${var.name_preffix}-sonar-scale-up-policy"
    depends_on              = [ "aws_appautoscaling_target.sonar_scale_target" ]
    service_namespace       = "ecs"
    resource_id             = "service/${aws_ecs_cluster.sonar_cluster.name}/${aws_ecs_service.sonar_service.name}"
    scalable_dimension      = "ecs:service:DesiredCount"
    step_scaling_policy_configuration {
        adjustment_type         = "ChangeInCapacity"
        cooldown                = 60
        metric_aggregation_type = "Maximum"
        step_adjustment {
            metric_interval_lower_bound = 0
            scaling_adjustment = 1
        }
    }
}
# Scaling Down Policy
resource "aws_appautoscaling_policy" "sonar_scale_down_policy" {
    name                    = "${var.name_preffix}-sonar-scale-down-policy"
    depends_on              = [ "aws_appautoscaling_target.sonar_scale_target" ]
    service_namespace       = "ecs"
    resource_id             = "service/${aws_ecs_cluster.sonar_cluster.name}/${aws_ecs_service.sonar_service.name}"
    scalable_dimension      = "ecs:service:DesiredCount"
    step_scaling_policy_configuration {
        adjustment_type         = "ChangeInCapacity"
        cooldown                = 60
        metric_aggregation_type = "Maximum"
        step_adjustment {
            metric_interval_lower_bound = 0
            scaling_adjustment = -1
        }
    }
}
# Scaling Target
resource "aws_appautoscaling_target" "sonar_scale_target" {
    service_namespace  = "ecs"
    resource_id        = "service/${aws_ecs_cluster.sonar_cluster.name}/${aws_ecs_service.sonar_service.name}"
    scalable_dimension = "ecs:service:DesiredCount"
    role_arn           = "${aws_iam_role.ecs_autoscale_role.arn}"
    min_capacity       = 1
    max_capacity       = 5
}
