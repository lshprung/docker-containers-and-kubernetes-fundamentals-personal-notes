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
kind: Pod
metadata:
  name: myapp-pod
  namespace: prod
spec:
  containers:
    - name: nginx-container
    - image: nginx
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
