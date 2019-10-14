
resource "random_pet" "name" {
 length    = "${var.pet_length}"
 separator = "${var.pet_sepator}"
}

