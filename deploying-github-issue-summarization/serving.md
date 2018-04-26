Once the trained model (_output_model.h5_) is available, it needs to be packaged up as a Docker Image. As the serving will be done via Seldon Core, the command below would build the required Docker Image containing your trained model. This has been done for you and uploaded as _gcr.io/kubeflow-images-public/issue-summarization:0.1_.

The commands below represent what's required to build the image.

```
docker run -v $(pwd)/my_model/:/my_model seldonio/core-python-wrapper:0.7 /my_model IssueSummarization 0.1 gcr.io --base-image=python:3.6 --image-name=gcr-repository-name/issue-summarization

cd build
./build_image.sh
```

## Gives cluster-admin role to the default service account in the ${NAMESPACE}
`kubectl create clusterrolebinding seldon-admin --clusterrole=cluster-admin --serviceaccount=${NAMESPACE}:default`{{execute}}

## Install the kubeflow/seldon package
Similar to how we defined the packages when deploying Kubeflow, we need to install the additional Seldon package.
`cd ~/my-kubeflow/; ks pkg install kubeflow/seldon`{{execute}}

## Generate the Seldon component and deploy it
As we've made a change to the configuration, it's required to generate the template containing Seldon and deploy it to the Kubernetes cluster.
```
ks generate seldon seldon --name=seldon --namespace=${NAMESPACE}
ks apply default -c seldon
```{{execute}}

## Deploy Trained Model via Seldon Core (seldon-serve-simple)
With the Seldon components deployed, it's possible to use this to serve our trained model via the Docker Image _gcr.io/kubeflow-images-public/issue-summarization:0.1_.  The approach below defines two replicas, this means we'll have two instances of our application available and load balanced by Kubernetes for reliability and performance.
```
ks generate seldon-serve-simple issue-summarization-model-serving \
  --name=issue-summarization \
  --image=gcr.io/kubeflow-images-public/issue-summarization:0.1 \
  --namespace=${NAMESPACE} \
  --replicas=2
ks apply default -c issue-summarization-model-serving
```{{execute}}

Disable the livenessProbe

`kubectl patch deployment -n kubeflow issue-summarization-issue-summarization  --type json   -p='[{"op": "remove", "path": "/spec/template/spec/containers/0/livenessProbe"}]'`{{execute}}

View the status of the deployment at `kubectl get pods -n ${NAMESPACE}`{{execute}}

## Query

Once deployed, it's possible to call the API and have a respond from our trained model.

```
curl -X POST -H 'Content-Type: application/json' -d '{"data":{"ndarray":[["issue overview add a new property to disable detection of image stream files those ended with -is.yml from target directory. expected behaviour by default cube should not process image stream files if user does not set it. current behaviour cube always try to execute -is.yml files which can cause some problems in most of cases, for example if you are using kuberentes instead of openshift or if you use together fabric8 maven plugin with cube"]]}}' http://[[HOST_IP]]:30080/seldon/issue-summarization/api/v0.1/predictions
```{{execute}}