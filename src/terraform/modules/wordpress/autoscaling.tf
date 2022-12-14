resource "aws_appautoscaling_target" "example" {
  max_capacity       = 3
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.example.name}/${aws_ecs_service.example.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "example" {
  name               = "${var.common["env_abbr"]}-${var.common["name"]}-scale"
  resource_id        = "service/${aws_ecs_cluster.example.name}/${aws_ecs_service.example.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 40 // CPUの平均使用率が40%になるように維持する
    scale_in_cooldown  = 60 // スケールインの間隔は60秒空ける
    scale_out_cooldown = 30 // スケールアウトの間隔は30秒空ける
  }
}
