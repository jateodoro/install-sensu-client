usage(){
        echo "$0 [-c <project name>] [-a <server address>] [-n <server name>] [-h <rabbitmq host>]"
}

while getopts ":c:a:n:h:" opt; do
        case $opt in
                c)
                        c=${OPTARG}
                        ;;
                a)
                        a=${OPTARG}
                        ;;
                n)
                        n=${OPTARG}
                        ;;
                h)
                        h=${OPTARG}
                        ;;
        esac
done

if [ -z "${c}" ] || [ -z "${a}" ] || [ -z "${n}" ] || [ -z "${h}" ]; then
        echo "This script needs parameters"
        usage
        exit 1
fi

sudo yum install -y policycoreutils-python wget && \
wget http://mirror.centos.org/centos/7/extras/x86_64/Packages/container-selinux-2.21-1.el7.noarch.rpm && \
sudo rpm -i container-selinux-2.21-1.el7.noarch.rpm && \
sudo yum install -y yum-utils && \
sudo yum install -y device-mapper-persistent-data lvm2 && \
sudo yum-config-manager --enable rhel-7-server-extras-rpms && \
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo && \
sudo yum makecache fast && \
sudo yum -y install docker-ce && \
systemctl enable docker && \
systemctl start docker && \
docker network create adopnetwork && \
rm -f container-selinux-2.9-4.el7.noarch.rpm && \
docker run --restart=always -d --name sensu-client --net="adopnetwork" --expose 4567 -v /:/rootfs:ro -v /var/run:/var/run:rw -v /var/lib/docker/:/var/lib/docker:ro -v /data/nfs/sensu-client/plugins/:/app/sensu/plugins -v /data/nfs/sensu-client/ssl:/ssl -e PLUGINS_DIR="/etc/sensu/plugins" -e JENKINS_PREFIX="jenkins" -e CLIENT_ADDRESS="${a}" -e CLIENT_NAME="${n}" -e SUB="basic" -e RABBITMQ_HOST="${h}" -e RABBITMQ_PORT=5672 -e RABBITMQ_USER=guest -e RABBITMQ_PASS=guest -e RABBITMQ_VHOST="/" -e SENSU_URL=sensu-uchiwa:3000 arypurnomoz/sensu-client && \
docker cp sensu-client:/tmp/run.sh . && \
sed -i "s/    \$ADDITIONAL_INFO/    \$ADDITIONAL_INFO,\n    \"tags\": {\n        \"client\": \"$c\", \n        \"environment\": \"$n\" \n    },\n    \"keepalive\": { \n        \"handlers\": [\"mailer\"],\n        \"thresholds\": { \n            \"warning\": 600, \n            \"critical\": 900 \n        } \n    }/g" run.sh && \
sed -i -e ':a' -e 'N' -e '$!ba' -e "s/\"ssl\":.*\n.*\n.*\n.*},//g" run.sh && \
docker cp run.sh sensu-client:/tmp/ && \
docker restart sensu-client

docker exec sensu-client rm -rf /etc/sensu/plugins && \
docker cp linux-plugins sensu-client:/etc/sensu/plugins && \
docker exec -it sensu-client /bin/bash -c "cd /opt/sensu/embedded/bin/ && ./gem install sensu-plugins-cpu-usage && ./gem install sensu-plugins-disk-checks" && \
rm -rf run.sh sensu-plugins
