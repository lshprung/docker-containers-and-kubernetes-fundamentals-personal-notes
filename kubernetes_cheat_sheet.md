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
