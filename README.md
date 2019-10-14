# tf-move-state
TF state move follow. not a real repo, just follow up

# Goal

Start with 1 folder with multiple state, end with 2 folder, separate state and module.
We will create 1 folder, and then we will separate into 2 different projects.

# How To 

Create 1 folder with random_pet and null provider

```terraform
resource "random_pet" "name" {
 length    = "4"
 separator = "-"
}

resource "null_resource" "hello" {
  provisioner "local-exec" {
    command = "echo Hello ${random_pet.name.id}"
  }
}
```

Run terraform apply, you should end with a new repo created, and state locally.

The goal of this lab is move the random_pet into a separate project.

Hints:
[move state](https://www.terraform.io/docs/commands/state/mv.html)
[modules](https://www.terraform.io/docs/configuration/modules.html)



- Create 1 folder for sample code, run terraform apply
- Create a folder for random_pet
  - Make code for a module
- Update code to use module
  - Terraform init
  - Use terraform state mv to rename the state
- Terraform apply should say the nothing to be created, state should persists.
- Terraform destroy should work and delete the existing state

# Run log 


## 1-st terrafrom apply 
```
terraform apply

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # null_resource.hello will be created
  + resource "null_resource" "hello" {
      + id = (known after apply)
    }

  # random_pet.name will be created
  + resource "random_pet" "name" {
      + id        = (known after apply)
      + length    = 4
      + separator = "-"
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

random_pet.name: Creating...
random_pet.name: Creation complete after 0s [id=mentally-weekly-sought-flamingo]
null_resource.hello: Creating...
null_resource.hello: Provisioning with 'local-exec'...
null_resource.hello (local-exec): Executing: ["/bin/sh" "-c" "echo Hello mentally-weekly-sought-flamingo"]
null_resource.hello (local-exec): Hello mentally-weekly-sought-flamingo
null_resource.hello: Creation complete after 0s [id=4404350176882817396]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```

## 2-nd plan after refactroing into module 
```
terraform plan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

random_pet.name: Refreshing state... [id=mentally-weekly-sought-flamingo]
null_resource.hello: Refreshing state... [id=4404350176882817396]

------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create
  - destroy

Terraform will perform the following actions:

  # random_pet.name will be destroyed
  - resource "random_pet" "name" {
      - id        = "mentally-weekly-sought-flamingo" -> null
      - length    = 4 -> null
      - separator = "-" -> null
    }

  # module.random_pet_mod.random_pet.name will be created
  + resource "random_pet" "name" {
      + id        = (known after apply)
      + length    = 4
      + separator = "-"
    }

Plan: 1 to add, 0 to change, 1 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
```
Now, moving state : 
```
terraform state mv random_pet.name module.random_pet_mod.random_pet.name 
Move "random_pet.name" to "module.random_pet_mod.random_pet.name"
Successfully moved 1 object(s).
```
Again `terraform apply`
```
terraform apply                                                         
module.random_pet_mod.random_pet.name: Refreshing state... [id=mentally-weekly-sought-flamingo]
null_resource.hello: Refreshing state... [id=4404350176882817396]

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```
Nothing, as expected.

# Destroy after move

```
 terraform destroy
module.random_pet_mod.random_pet.name: Refreshing state... [id=mentally-weekly-sought-flamingo]
null_resource.hello: Refreshing state... [id=4404350176882817396]

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # null_resource.hello will be destroyed
  - resource "null_resource" "hello" {
      - id = "4404350176882817396" -> null
    }

  # module.random_pet_mod.random_pet.name will be destroyed
  - resource "random_pet" "name" {
      - id        = "mentally-weekly-sought-flamingo" -> null
      - length    = 4 -> null
      - separator = "-" -> null
    }

Plan: 0 to add, 0 to change, 2 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

null_resource.hello: Destroying... [id=4404350176882817396]
null_resource.hello: Destruction complete after 0s
module.random_pet_mod.random_pet.name: Destroying... [id=mentally-weekly-sought-flamingo]
module.random_pet_mod.random_pet.name: Destruction complete after 0s

Destroy complete! Resources: 2 destroyed.
```
