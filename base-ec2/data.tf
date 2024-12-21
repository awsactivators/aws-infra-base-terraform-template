data "cloudinit_config" "user_data" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "user_data.sh"
    content_type = "text/x-shellscript"

    content = templatefile("${path.module}/user_data.tpl", {
      hostname          = var.hostname
      username          = var.username
      public_key        = var.public_key
      instance_role_arn = aws_iam_role.instance_role.arn
      falcon_cid        = var.falcon_cid
      authKey           = var.tailscale_authkey
      log_config_json = jsonencode({
        agent : {
          run_as_user : "root"
        }
        logs : {
          logs_collected : {
            files : {
              collect_list : [
                {
                  file_path : "/var/log/syslog",
                  log_group_name : aws_cloudwatch_log_group.main.name
                  log_stream_name : "/var/log/syslog"
                },
                {
                  file_path : "/var/log/audit/audit.log",
                  log_group_name : aws_cloudwatch_log_group.main.name
                  log_stream_name : "/var/log/audit/audit.log"
                },
                {
                  file_path : "/var/log/auth.log",
                  log_group_name : aws_cloudwatch_log_group.main.name
                  log_stream_name : "/var/log/auth.log"
                }
              ]
            }
          }
        }
      })
    })
  }

  part {
    filename     = "custom_user_data"
    content_type = "text/x-shellscript"
    content      = var.ec2_user_data
  }
}
