# Kubernetes Cheat Sheet

## kubectl CLI

### Context

|                                      |                             |
|--------------------------------------|-----------------------------|
|`kubectl config current-context`      |Get the current context      |
|`kubectl config get-contexts`         |List all context             |
|`kubectl config use-context [contextName]`|Set the current context  |
|`kubectl config delete-context [contextName]`|Delete a context from the config file|

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

### YAML required properties

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
