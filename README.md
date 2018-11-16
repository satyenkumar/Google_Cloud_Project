Welcome to my GCP

I am aiming this project to demonstrate how we can use public cloud like GCP or private cloud like VMware to run k8s kubernetes cluster.

Starting from script:
./deploy_day or ./deploy_night

This script is an example how to select Zone from GCP and populate the 2 instances to be ready. I picked either day or night based on the regional workload. I avoid the case that high demand and I have to wait long time until the VM instances complete.

When you plan to install GCloud in the MACOS:

#### 1. DOWNLOAD GCLOUD FOR MACOS ####

Step: google search and install software.

#### 2. KUBECTL BASH COMPLETION ####

https://github.com/kubernetes/kubernetes/issues/48575

Step 1: upgrade BASH to version 4.x

Upgrade bash to ver. 4+, https://coderwall.com/p/dmuxma/upgrade-bash-on-your-mac-os
```
> brew install bash
> sudo bash -c "echo $(brew --prefix)/bin/bash >> /private/etc/shells"
> Use system preferences 
	-> Users & Groups (unlock pref pane) 
	-> right click on your accountAdvanced Options... and change Login shell option to /usr/local/bin/bash
```

Step 2: brew install bash-completion@2
```
brew install bash-completion@2
```

Step 3: Run commands

```
$ kubectl completion bash > ~/.kube/kubectl_autocompletion
```

Step 4: update .bash_profile

```
if [ -f /usr/local/share/bash-completion/bash_completion ]; then
  . /usr/local/share/bash-completion/bash_completion
fi

source ~/.kube/kubectl_autocompletion
```
