module "random_pet_mod" {
  source = "./random_pet_mod"
  pet_length = "4"
  pet_sepator = "-"
}

resource "null_resource" "hello" {
  provisioner "local-exec" {
    command = "echo Hello ${module.random_pet_mod.name_id}"
  }
}
