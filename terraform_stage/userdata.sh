# 없으면 설치
sudo yum install -y ruby
cd /home/ec2-user
sudo wget https://aws-codedeploy-ap-northeast-2.s3.amazonaws.com/latest/install
sudo chmod +x ./install
sudo ./install auto

# 설치 후 실행
sudo service codedeploy-agent start

# db 설정
cat <<EOF > /home/ec2-user/app/.env
DB_HOST=$${db_name}
DB_USER=$${db_user}
DB_PASS=$${db_pass}
DB_NAME=$${db_name}
EOF
