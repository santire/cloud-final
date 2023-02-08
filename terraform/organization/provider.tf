provider "aws" {
  region = "us-east-1"

  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "final-cloud"

  default_tags {
    tags = {
      author     = "Grupo 1"
      version    = 1
      university = "ITBA"
      subject    = "Cloud Computing"
      created-by = "terraform"
    }
  }
}
