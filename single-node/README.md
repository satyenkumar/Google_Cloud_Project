#### Single Master ####

- Step 1: set environment: region, zone and KubeConfig
```
. ./set-env
```

- Step 2: request a single VM instance
```
./deploy_single_node
```

- Step 3: fetch /etc/kubernetes/admin.conf from a completed VM instance
```
./fetch_config
```

- Step 4: set external(public) IP 
```
./setup_single_master
```

### Troubleshooting ###

$ source <(kubectl completion bash)
$ export KUBECONFIG=/etc/kubernetes/admin.conf

$ kubectl get nodes -o wide
NAME                STATUS     ROLES    AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE       KERNEL-VERSION    CONTAINER-RUNTIME
boonchu-cluster-1   NotReady   master   32m   v1.12.2   10.168.0.2    <none>        Ubuntu 18.10   4.18.0-1002-gcp   docker://18.6.1

$ kubectl get pods -n kube-system
NAME                                        READY   STATUS    RESTARTS   AGE
coredns-576cbf47c7-j46c5                    0/1     Pending   0          30m
coredns-576cbf47c7-rdt47                    0/1     Pending   0          30m
etcd-boonchu-cluster-1                      1/1     Running   0          29m
kube-apiserver-boonchu-cluster-1            1/1     Running   0          29m
kube-controller-manager-boonchu-cluster-1   1/1     Running   1          29m
kube-proxy-n4lgm                            1/1     Running   0          30m
kube-scheduler-boonchu-cluster-1            1/1     Running   1          30m

$ kubectl describe pods -n kube-system --kubeconfig /etc/kubernetes/admin.conf coredns-576cbf47c7-rdt47 | tail -5
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type     Reason            Age                    From               Message
  ----     ------            ----                   ----               -------
  Warning  FailedScheduling  4m24s (x154 over 29m)  default-scheduler  0/1 nodes are available: 1 node(s) had taints that the pod didn't tolerate.
