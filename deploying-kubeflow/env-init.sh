mkdir kubeflow
git clone https://github.com/katacoda/kubeflow kubeflow
echo "  externalIPs:" >> kubeflow/components/jupyterhub/manifests/service.yaml
echo "  - 172.17.0.12" >> kubeflow/components/jupyterhub/manifests/service.yaml
