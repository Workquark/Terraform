
# resource "aws_instance" "docker_instance" {
#   ami           = "ami-0912f71e06545ad88"
#   instance_type = "t3.micro" # Change as per your requirement
#   # key_name        = "your-ssh-key-name" # Replace with your SSH key name
#   # security_groups = ["default"] # You can specify a custom security group if needed
#   subnet_id = "subnet-0895dbfb40ae0ac69"

#   vpc_security_group_ids = [aws_security_group.twingate.id]

#   # User Data to install Docker
#   user_data = <<-EOF
#               #!/bin/bash
#               sudo yum update -y
#               sudo amazon-linux-extras install docker -y
#               sudo service docker start
#               sudo usermod -a -G docker ec2-user
#               sudo docker run -d
#               --sysctl net.ipv4.ping_group_range="0 2147483647"
#               --env TWINGATE_NETWORK="workquark0403"
#               --env TWINGATE_ACCESS_TOKEN="eyJhbGciOiJFUzI1NiIsImtpZCI6Im9mWVdfTGZkT0VBYjVPUzF1QXZzdFpYa2ZoS1RmQms4aDBwbEpXQ2JqWW8iLCJ0eXAiOiJEQVQifQ.eyJudCI6IkFOIiwiYWlkIjoiNDY4OTQyIiwiZGlkIjoiMjA1NDIxNiIsImp0aSI6Ijk4NzkwYjJlLWZmN2EtNGRmYS1iNzExLTBmNDM4Y2Q0MDhkYyIsImlzcyI6InR3aW5nYXRlIiwiYXVkIjoid29ya3F1YXJrMDQwMyIsImV4cCI6MTc0MTQ5NTkzMywiaWF0IjoxNzQxNDkyMzMzLCJ2ZXIiOiI0IiwidGlkIjoiMTM5MjI3Iiwicm53IjoxNzQxNDkyNjMzLCJybmV0aWQiOiIxODIyNTcifQ.5byeT-prEIMfczwI7hYMucDXyjvMUPDs9QESJSzijBySWzgrw4sWBvikXvC0Yu1J8ILpo19WkanlXjmBwNOWlg"
#               --env TWINGATE_REFRESH_TOKEN="vQoJywTiNjmwOgWgMK8tW7MsK9Z2qzIUZwmth9Vk1a3oyuysPKTmxwyh2yzaDeQiYUYhCAOGp_unh5ZdxevLsgwU2BgWH9fzlO-RzTedm04ssaqflx07nOez-41AlW5t4A5yyw"
#               --env TWINGATE_LABEL_HOSTNAME="`hostname`"
#               --env TWINGATE_LABEL_DEPLOYED_BY="docker"
#               --name "twingate-dev"
#               --restart=unless-stopped
#               --pull=always
#               twingate/connector:1
#               EOF

#   tags = {
#     Name = "Twingate"
#   }
# }
