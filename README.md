#### Welcome to my Google Certified Professional.

When you plan to install GCloud SDK.

#### 1. DOWNLOAD GCLOUD SDK for macOS. ####

Step: [Install SDK](https://cloud.google.com/sdk/docs/quickstart-macos)

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

# Update .bash_profile

if [ -f /usr/local/share/bash-completion/bash_completion ]; then
  . /usr/local/share/bash-completion/bash_completion
fi
```

Step 3: Install bash completion for 'gcloud'.

```
$ curl https://raw.githubusercontent.com/google-cloud-sdk/google-cloud-sdk/master/completion.bash.inc \
  | sudo tee /usr/local/etc/bash_completion.d/gcloud_bash
```

#### Links.

- [GCloud Developer Ref.](https://cloud.google.com/sdk/gcloud/reference/)
- [Google API Explorer Compute Instances.](https://developers.google.com/apis-explorer/#s/compute/v1/)
- [Choose the right options for GDP compute.](https://cloud.google.com/blog/products/gcp/choosing-the-right-compute-option-in-gcp-a-decision-tree)
