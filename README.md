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

- `terraform apply`
 ```
 random_pet.name: Creating...
 random_pet.name: Creation complete after 0s [id=widely-horribly-equipped-mako]
 null_resource.hello: Creating...
 null_resource.hello: Provisioning with 'local-exec'...
 null_resource.hello (local-exec): Executing: ["/bin/sh" "-c" "echo Hello widely-horribly-equipped-mako"]
 null_resource.hello (local-exec): Hello widely-horribly-equipped-mako
 null_resource.hello: Creation complete after 0s [id=39383931994062867]

 Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
 ```
- 
