#! /bin/bash
set -e
set -x

sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

cat <<EOF > kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo mv kubernetes.list /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y apt-transport-https

# KUBERNETES_VERSION=$(curl -s -H "Metadata-Flavor: Google" \
#  http://metadata.google.internal/computeMetadata/v1/instance/attributes/kubernetes-version)

# version 1.11.0
KUBERNETES_VERSION=1.11.2
API_VERSION=kubeadm.k8s.io/v1alpha2
API_KIND=MasterConfiguration
sudo apt-get install -y docker.io
sudo apt-get install -y kubelet=1.11.2-00 kubeadm=1.11.2-00 kubectl=1.11.2-00

# version 1.12.2
# KUBERNETES_VERSION=1.12.2
# API_VERSION=kubeadm.k8s.io/v1alpha3
# API_KIND=InitConfiguration
# sudo apt-get install -y docker.io
# sudo apt-get install -y kubelet=1.12.2-00 kubeadm=1.12.2-00 kubectl=1.12.2-00

sudo systemctl enable docker.service

cat <<EOF > 20-cloud-provider.conf
Environment="KUBELET_EXTRA_ARGS=--cloud-provider=gce"
EOF
sudo mv 20-cloud-provider.conf /etc/systemd/system/kubelet.service.d/
sudo systemctl daemon-reload
sudo systemctl restart kubelet

EXTERNAL_IP=$(curl -s -H "Metadata-Flavor: Google" \
  http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)
INTERNAL_IP=$(curl -s -H "Metadata-Flavor: Google" \
  http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip)


# 
cat <<EOF > kubeadm.conf
apiVersion: ${API_VERSION}
kind: ${API_KIND}
apiServerCertSANs:
  - 10.96.0.1
  - ${EXTERNAL_IP}
  - ${INTERNAL_IP}
apiServerExtraArgs:
  admission-control: PodPreset,Initializers,GenericAdmissionWebhook,NamespaceLifecycle,LimitRanger,ServiceAccount,PersistentVolumeLabel,DefaultStorageClass,DefaultTolerationSeconds,NodeRestriction,ResourceQuota
  feature-gates: AllAlpha=true
  runtime-config: api/all
cloudProvider: gce
kubernetesVersion: ${KUBERNETES_VERSION}
networking:
  podSubnet: 192.168.0.0/16
EOF

sudo kubeadm init --config=kubeadm.conf

sudo chmod 644 /etc/kubernetes/admin.conf

sudo kubectl taint nodes --all node-role.kubernetes.io/master- \
  --kubeconfig /etc/kubernetes/admin.conf

# https://stackoverflow.com/questions/46360361/invalid-x509-certificate-for-kubernetes-master
# https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/
# -apiserver-cert-extra-sans stringSlice: 
#  Optional extra Subject Alternative Names (SANs) to use for the API Server serving certificate. Can be both IP addresses and DNS names.
#
sudo rm /etc/kubernetes/pki/apiserver.*
sudo kubeadm alpha phase certs all --apiserver-advertise-address=0.0.0.0 --apiserver-cert-extra-sans=${EXTERNAL_IP}
sudo docker rm -f `sudo docker ps -q -f 'name=k8s_kube-apiserver*'`
sudo systemctl restart kubelet

# CNI - Calico networking installation
# https://docs.projectcalico.org/v2.6/getting-started/kubernetes/installation/
# kubectl apply  -f https://docs.projectcalico.org/v2.6/getting-started/kubernetes/installation/hosted/kubeadm/1.5/calico.yaml \
# --kubeconfig /etc/kubernetes/admin.conf

# CNI - Flannels
# kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/bc79dd1505b0c8681ece4de4c0d86c5cd2643275/Documentation/kube-flannel.yml \
# --kubeconfig /etc/kubernetes/admin.conf

# CNI - Weave
# kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')" \
# --kubeconfig /etc/kubernetes/admin.conf
