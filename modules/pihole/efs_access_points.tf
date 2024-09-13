resource "aws_efs_access_point" "pihole_access_point_config" {
  file_system_id = aws_efs_file_system.efs_for_fargate.id
  posix_user {
    gid = 1000
    uid = 1000
  }
  root_directory {
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = "0777"
    }
    path = "/etc/pihole"
  }
  tags = {
    Name = "filebrowser_access_point_config"
  }
}

resource "aws_efs_access_point" "pihole_access_point_dnsmasq" {
  file_system_id = aws_efs_file_system.efs_for_fargate.id
  posix_user {
    gid = 1000
    uid = 1000
  }
  root_directory {
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = "0777"
    }
    path = "/etc/dnsmasq.d"
  }
  tags = {
    Name = "filebrowser_access_point_db"
  }
}