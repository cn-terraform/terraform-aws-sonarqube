# Network project remote state
data "terraform_remote_state" "aws_simulator_network" {
  backend = "s3"
  config = {
    bucket     = "movai.terraform"
    key    = "simulator-network-workspace/dev/aws-simulator-network.tfstate"
    region     = "us-east-1"
  }
}
