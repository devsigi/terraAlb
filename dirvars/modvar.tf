locals{
  worksc="${terraform.workspace}"
  
  env_list = {
    default="dev_web"
    dev="dev_web"
    prod="prod_web"
  }

  xenv = "${lookup(local.env_list, local.worksc)}"
}

output "env"{
  value = "${local.xenv}"
}
