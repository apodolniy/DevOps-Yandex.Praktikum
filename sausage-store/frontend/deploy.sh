#! /bin/bash

sudo docker login -u ${CI_REGISTRY_USER} -p ${CI_REGISTRY_PASSWORD} ${CI_REGISTRY}
sudo docker network create -d bridge sausage_network || true
sudo docker rm -f sausage-frontend || true
sudo docker run -d --name sausage-frontend -v "/tmp/${CI_PROJECT_DIR}/frontend/default.conf:/etc/nginx/conf.d/default.conf" \
     --restart=always -p 80:80 \
     --env REPORT_PATH=/var/www-data/htdocs \
     --env REPORTS_MONGODB_URI=mongodb://${MONGO_USER}:${MONGO_PASSWORD}@${MONGO_HOST}:27018/${MONGO_DATABASE}?tls=true \
     --network=sausage_network \
     "${CI_REGISTRY_IMAGE}"/sausage-frontend:${VERSION} 
