locals{
  worksc="${terraform.workspace}"
  
  env_list = {
    default="devAlb"
    dev="devAlb"
    prod="prodAlb"
  }

  xenv = "${lookup(local.env_list, local.worksc)}"
}

output "env"{
  value = "${local.xenv}"
}
