# Kubernetes Cheat Sheet

## kubectl CLI

### Context

|                                      |                             |
|--------------------------------------|-----------------------------|
|`kubectl config current-context`      |Get the current context      |
|`kubectl config get-contexts`         |List all context             |
|`kubectl config use-context [contextName]`|Set the current context  |
|`kubectl config delete-context [contextName]`|Delete a context from the config file|

### Namespace

|                                      |                             |
|--------------------------------------|-----------------------------|
|`kubectl get namespace`               |List all namespaces          |
|`kubectl get ns`                      |Shortcut                     |
|`kubectl config set-context --current --namespace=[namespaceName]`|Set the current context to use a namespace|
|`kubectl create ns`                   |Create a namespace           |
|`kubectl delete ns`                   |Delete a namespace           |
|`kubectl get pods --all-namespaces`   |List all pods in all namespaces|

### Nodes

|                                      |                             |
|--------------------------------------|-----------------------------|
|`kubectl get nodes`                   |Get a list of all the installed nodes|
|`kubectl describe node [NAME]`        |Get some info about a node   |        

### Pod

|                                      |                             |
|--------------------------------------|-----------------------------|
|`kubectl create -f [pod-definition.yml]`|Create a pod               |
|`kubectl run [podname] --image=busybox -- /bin/sh -c "sleep 3600"`|Run a pod (example)| 
|`kubectl get pods`                    |List the running pods        |
|`kubectl get pods -o wide`            |Same but with more info      |
|`kubectl describe pod [podname]`      |Show pod info                |
|`kubectl get pod [podname] -o yaml > file.yaml`|Extract the pod definition in YAML and save it to a file|
|`kubectl exec -it [podname] -- sh`    |Interactive mode             |
|`kubectl exec -it [podname] -c [containername] -- sh`|Exec into a pod|
|`kubectl delete -f [pod-definition.yml]`|Delete a pod               |
|`kubectl delete pod [podname]`        |Same using the pod's name    |
|`kubectl logs [podname] -c [containername]`|Get the logs for a container|

### ReplicaSets

|                                      |                             |
|--------------------------------------|-----------------------------|
|`kubectl apply -f [definition.yaml]`  |Create a ReplicaSet          |
|`kubectl get rs`                      |List ReplicaSets             |
|`kubectl describe rs [rsName]`        |Get info                     |
|`kubectl delete -f [definition.yaml]` |Delete a ReplicaSet          |
|`kubectl delete rs [rsName]`          |Same but using the ReplicaSet name|

### Deployments

|                                      |                             |
|--------------------------------------|-----------------------------|
|`kubectl create deploy [deploymentName] --image=busybox --replicas=3 --port=80`|The imperative way|
|`kubectl apply -f [definition.yaml]`  |Create a deployment          |
|`kubectl get deploy`                  |List deployments             |
|`kubectl describe deploy [deploymentName]`|Get info                 |
|`kubectl get rs`                      |List replicasets             |
|`kubectl delete -f [definition.yaml]` |Delete a deployment          |
|`kubectl delete deploy [deploymentName]`|Same but using the deployment name|

### DaemonSets

|                                      |                             |
|--------------------------------------|-----------------------------|
|`kubectl apply -f [definition.yaml]`  |Create a DaemonSet           |
|`kubectl get ds`                      |List DaemonSets              |
|`kubectl describe ds [rsName]`        |Get info                     |
|`kubectl delete -f [definition.yaml]` |Delete a DaemonSet           |
|`kubectl delete ds [rsName]`          |Same but using the DaemonSet name|

### StatefulSets

|                                      |                             |
|--------------------------------------|-----------------------------|
|`kubectl apply -f [definition.yaml]`  |Create a StatefulSet         |
|`kubectl get sts`                     |List StatefulSets            |
|`kubectl describe sts [rsName]`       |Get info                     |
|`kubectl delete -f [definition.yaml]` |Delete a StatefulSet         |
|`kubectl delete sts [rsName]`         |Same but using the StatefulSet name|

### Jobs

|                                      |                             |
|--------------------------------------|-----------------------------|
|`kubectl create job [jobName] --image=busybox`|The imperative way   |
|`kubectl apply -f [definition.yaml]`  |Create a Job                 |
|`kubectl get job`                     |List jobs                    |
|`kubectl describe job [jobName]`      |Get info                     |
|`kubectl delete -f [definition.yaml]` |Delete a job                 |
|`kubectl delete job [jobName]`        |Same but using the Job name  |

### CronJobs

|                                      |                             |
|--------------------------------------|-----------------------------|
|`kubectl create cronjob [jobName] --image=busybox --schedule="*/1 * * * *" -- bin/sh -c "date;"`|The imperative way|
|`kubectl apply -f [definition.yaml]`  |Create a CronJob             |
|`kubectl get cj`                      |List CronJobs                |
|`kubectl describe cj [jobName]`       |Get info                     |
|`kubectl delete -f [definition.yaml]` |Delete a CronJob             |
|`kubectl delete cj [jobName]`         |Same but using the CronJob name|

### RollingUpdate

|                                      |                             |
|--------------------------------------|-----------------------------|
|`kubectl apply -f [definition.yaml]`  |Update a deployment          |
|`kubectl rollout status`              |Get the progress of the update|
|`kubectl rollout history deployment [deploymentname]`|Get the history of the deployment|
|`kubectl rollout undo [deploymentname]`|Rollback a deployment       |
|`kubectl rollout undo [deploymentname] --to-revision=[revision#]`|Rollback to a revision number|

### ClusterIP

|                                      |                             |
|--------------------------------------|-----------------------------|
|`kubectl expose po [podName] --port=80 --target-port=8080 --name=frontend|Create a service to expose a pod|
|`kubectl expose deploy [deployName] --port=80 --target-port=8080`|Create a service to expose a deployment|
|`kubectl apply -f [definition.yaml]`  |Deploy the service           |
|`kubectl get svc`                     |Get the services list        |
|`kubectl get svc -o wide`             |Get extra info               |
|`kubectl describe svc [serviceName]`  |Describe the service         |
|`kubectl delete -f [definition.yaml]` |Delete the service           |
|`kubectl delete svc [serviceName]`    |Delete the service using it's name|

### NodePort

|                                      |                             |
|--------------------------------------|-----------------------------|
|`kubectl expose po [podName] --port=80 --target-port=8080 --type=NodePort`|Create a service to expose a pod|
|`kubectl expose deploy [deployName] --port=80 --target-port=8080 --type=NodePort --name=frontend`|Create a service to expose a deployment|
|`kubectl apply -f [definition.yaml]`  |Deploy the service           |
|`kubectl get svc`                     |Get the services list        |
|`kubectl get svc -o wide`             |Get extra info               |
|`kubectl describe svc [serviceName]`  |Describe the service         |
|`kubectl delete -f [definition.yaml]` |Delete the service           |
|`kubectl delete svc [serviceName]`    |Delete the service using it's name|

### Misc.

|                                      |                             |
|--------------------------------------|-----------------------------|
|`kubectl create -f [YAML file]`       |Create an object using YAML  |

---

### `kubectx`

- Separate program that acts as an alias for `kubectl config use-context`
    - *Fast way to switch between clusters and namespaces in kubectl*

---

### Declarative vs Imperative

#### Declarative Example - YAML File

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app: myapp
    type: front-end
spec:
  containers:
    name: nginx-container
    image: nginx
```

#### Imperative Example - Series of commands

```sh
kubectl run mynginx --image=nginx --port=80

kubectl create deploy mynginx --image=nginx --port=80 --replicas=3

kubectl create service nodeport myservice --targetPort=8080

kubectl delete pod nginx
```

### Pod definition - required properties

- Root level required properties
    - `apiVersion`
        - Api version of the object
    - `kind`
        - type of object
    - `metadata.name`
        - unique name for the object
    - `metadata.namespace`
        - scoped environment name (will default to current)
    - `spec`
        - object specifications or desired state

---

### Namespace Example

Namespace definition:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: prod
```

Pod definition:

```yaml
apiVersion: v1
# Object type
kind: Pod
metadata:
  name: myapp-pod
  namespace: prod
  # Labels are used to identify, describe and group related sets of objects or resources together
  labels:
    app: myapp
    type: front-end
spec:
  containers:
  - name: nginx-container
    image: nginx
    ports:
      # Listening port
    - containerPort: 80
      name: http
      protocol: TCP
    # Environment Variables
    env:
    - name: DBCON
      value: connectionstring
    # Equiv to Docker ENTRYPOINT
    command: ["/bin/sh", "-c"]
    args: ["echo ${DBCON}"]
```

---

### Other kinds of YAML definitions

#### NetworkPolicy Example

```yaml
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  namespace: clientb
  name: deny-from-other-namespaces
spec:
  podSelector:
    matchLabels:
  ingress:
  - from:
    - podSelector: {}
```

#### ResourceQuota Example

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
  namespace: prod
spec:
  hard:
    pods: "10"
    limits.cpu: "5"
    limits.memory: 10Gi
```

#### Pod definition

---

### Pod state

|                              |                                        |
|------------------------------|----------------------------------------|
|Pending                       |Accepted but not yet created            |
|Running                       |Bound to a node                         |
|Succeeded                     |Exited with status 0                    |
|Failed                        |All containers exit and at least one exited with non-zero status|
|Unknown                       |Communication issues with the pod       |
|CrashLoopBackOff              |Started crashed, started again, and then crashed again|

---

### Init Containers

Example pod definition that uses init containers

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app: myapp
spec:
  # App container
  containers:
  - name: myapp-container
    image: busybox
  # Init containers (these will run before the app container)
  initContainers:
  - name: init-myservice
    image: busybox:1.28
    command: ['sh', '-c', "until nslookup mysvc.namespace.svc.cluster.local; do echo waiting for my service; sleep 2; done"]
  - name: init-mydb
    image: busybox:1.28
    command: ['sh', '-c', "until lookup mydb.namespace.svc.cluster.local; do echo waiting for mydb; sleep 2; done"]
```

---

### Multi-Containers Pods

Example of defining multiple containers in a single pod definition

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: two-containers
spec:
  restartPolicy: Always
  containers:
  # Container #1
  - name: mynginx
    image: nginx
    ports:
      - containerPort: 80
  # Container #2
  - name: mybox
    image: busybox
    ports:
      - containerPort: 81
    command:
      - sleep
      - "3600"
```

---

### ReplicaSets

Example ReplicaSet definition

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: rs-example
spec:
  replicas: 3 # desired number of instances
  selector:
    matchLabels:
      app: nginx
      env: front-end
  template:
    metadata:
      labels:
        app: nginx
        type: front-end
    spec:
      containers:
      - name: nginx
        image: nginx:stable-alpine
        ports:
        - containerPort: 80
```

- Top section is specific to ReplicaSets
- Section under `template:` specifies the pods you want to run

---

### Deployments

Example Deployment definition

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deploy-example
spec:
  replicas: 3 # number of pod instances
  revisionHistoryLimit: 3 # number of previous iterations to keep
  selector:
    matchLabels:
      app: nginx
      env: prod
  strategy:
    # Possible strategies are RollingUpdate and Recreate
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
  template:
    metadata:
      labels:
        app: nginx
        type: prod
    spec:
      containers:
      - name: nginx
        image: nginx:stable-alpine
        ports:
        - containerPort: 80
```

- Like with ReplicaSets, the section under `template:` specifies the pods you want to run

---

### DaemonSet

Example DaemonSet definition

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: daemonset-example
  labels:
    app: daemonset-example
spec:
  selector:
    matchLabels:
      app: daemonset-example
  template:
    metadata:
      labels:
        app: daemonset-example
    spec:
      tolerations:
      - key: node-role.kubernetes.io/master
        effect: NoSchedule
      containers:
      - name: busybox
        image: busybox
        args:
        - sleep
        - "10000"
```

---

### Job

Example Job definition

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: pi
spec:
  activeDeadlineSeconds 30 # Max seconds to run
  parallelism: 3 # How many pods should run in parallel
  completions: 3 # How many successful pod completions are needed to mark a job completed
  template:
    spec:
      containers:
      - name: pi
        image: perl
        command: ["perl", "-Mbignum=bpi", "-wle", "print bpi(2000)"]
      restartPolicy: Never # Default is Always
```

---

### CronJob

Example CronJob definition

```yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: hello-cron
spec:
  schedule: "* * * * *" # Cron format string
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: busybox
            image: busybox
            command: ["echo", "Hello from the CronJob"]
          restartPolicy: Never
```
