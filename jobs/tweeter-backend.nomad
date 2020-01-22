job "tweeter-backend" {
  datacenters = ["dc1"]

  type = "service"

  group "backend" {
    count = 1

    ephemeral_disk {
      size = 300
    }

    task "postgres" {
      driver = "docker"

      config {
        image = "postgres:11.1"

        port_map {
          db = 5432
        }
      }

      resources {
        cpu    = 500 # MHz
        memory = 256 # MB

        network {
          mbits = 10
          port "db" {}
        }
      }
    }

    task "tweeter-backend" {
      driver = "docker"

      config {
        image = "tweetium/tweeter-backend:631043cf52d21a641b23895bea46693f7dd03b38"

        port_map {
          web = 80
        }
      }

      env {
        DATABASE_URL = "postgresql://postgres:postgres@${NOMAD_ADDR_postgres_db}/postgres?sslmode=disable"
        JWT_SECRETS_MAP = "{ \"0\": \"4e054f2e-7436-4525-8fc6-d5801d483697\" }"
        JWT_SECRETS_CURRENT_KEY = 0
      }

      resources {
        cpu    = 250 # MHz
        memory = 256 # MB

        network {
          mbits = 10
          port "web" {
            static = 80
          }
        }
      }
    }
  }
}
