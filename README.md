Welcome to _demo project_
===============================

**PLEASE, BEFORE EXECUTING ANY COMMANDS, MAKE SURE THE GENERATED CODE IS CORRECT!**

***Installation***

Make sure you have Terraform (version >= 0.12) installed on your system, and available in your PATH. You can download the latest Terraform build for your OS [here](https://www.terraform.io/downloads.html).

Also, make sure you have a DigitalOcean account set up and a DigitalOcean API key.

Because you've also chosen to create a DigitalOcean Spaces, you'll also need the access key and secret key from DigitalOcean.

Once you have it all installed, you're ready for the next steps!

***Init Terraform on your modules***

```bash
$ cd dns
$ terraform init
$ terraform plan
$ terraform apply
```

This will: 

* Download the latest DigitalOcean Terraform provider locally, for the DNS module.
* Show you a plan of what Terraform will be doing for you if you were to apply the changes.
* Apply the changes to your DigitalOcean account, creating all resources required.

Do the same for the ssh-keys module:

```bash
$ cd ssh-keys
$ terraform init
$ terraform plan
$ terraform apply
```

Great, now our DigitalOcean account will have all domains set up, and the SSH keys needed to access the servers prepared, too.

Let's actually create our environment now:

```bash
$ cd app/envs/staging
$ terraform init
$ terraform plan
$ terraform apply
```

This will set up our **Staging** environment.

