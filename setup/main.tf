provider "aws" {
  profile = "${var.profile}"
  region  = "${var.region}"
}

module "backend" {
  source = "../modules/backends/"

  bucket         = "${var.bucket}"
  dynamodb_table = "${var.dynamodb_table}"
  key            = "${var.key}"
}
