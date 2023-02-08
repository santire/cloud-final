provider "aws" {
  region = "us-east-1"

  shared_credentials_files = ["/home/jsuarezb/.aws/credentials"]
  profile                  = "itba-cloud"

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