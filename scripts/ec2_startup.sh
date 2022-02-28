#! /bin/bash

cat << EOF > /home/ec2-user/startup.sh
sudo amazon-linux-extras install docker
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo yum install pip git python3 tmux -y
sudo pip install docker-compose --ignore-installed requests

EOF

chmod +x /home/ec2-user/startup.sh
bash /home/ec2-user/startup.sh
