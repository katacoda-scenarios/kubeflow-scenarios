ssh root@host01 "curl http://assets.joinscrapbook.com/k8s/ks-linux-amd64 -o /usr/local/bin/ks"
ssh root@host01 "mkdir kubeflow && git clone https://github.com/katacoda/kubeflow-ksonnet.git kubeflow && sed -i 's/\$HOSTIP/[[HOST_IP]]/g' kubeflow/katacoda.yaml && sed -i 's/\$HOST2IP/[[HOST2_IP]]/g' kubeflow/katacoda.yaml"
ssh root@[[HOST_IP]] "curl -L https://katacoda.com/kubeflow/scenarios/deploying-kubeflow-with-ksonnet/assets/cat.jpg -o /root/cat.jpg"
ssh root@[[HOST2_IP]] "curl -L https://katacoda.com/kubeflow/scenarios/deploying-kubeflow-with-ksonnet/assets/cat.jpg -o /root/cat.jpg"
ssh root@[[HOST_IP]] "curl -L https://katacoda.com/kubeflow/scenarios/deploying-kubeflow-with-ksonnet/assets/katacoda.jpg -o /root/katacoda.jpg"
ssh root@[[HOST2_IP]] "curl -L https://katacoda.com/kubeflow/scenarios/deploying-kubeflow-with-ksonnet/assets/katacoda.jpg -o /root/katacoda.jpg"
