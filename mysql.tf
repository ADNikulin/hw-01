resource "random_password" "ROOT_PASSWORD" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "random_password" "MYSQL_PASSWORD" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "docker_image" "mysql" {
  name         = "mysql:8"
  keep_locally = true
}

resource "docker_container" "mysql" {
  image = docker_image.mysql.image_id
  name  = "mysql"

  env = ["MYSQL_ROOT_PASSWORD=${random_password.ROOT_PASSWORD.result}","MYSQL_DATABASE=wordpress", "MYSQL_USER=wordpress","MYSQL_PASSWORD=${random_password.MYSQL_PASSWORD.result}", "MYSQL_ROOT_HOST=\"%\""]

  ports {
    internal = 3306
    external = 3306
  }
}
