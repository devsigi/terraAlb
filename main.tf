provider "aws"{
    region = var.region

    access_key = var.accessKey
    secret_key = var.secretKey
#    profile = "aws cli profile id"	# which was set using aws config --profile
}

module "modsg" {
  vpcid = var.vpcid
#  sgid = var.sgid
  source = "./dirsg"
}

module "modalb"{
  vpcid = var.vpcid
  sgid = "${module.modsg.outsgalbid}"
  subnetid = var.subnetid


  source = "./diralb"
}

 output outtg_arn{
	value=module.modalb.outtg_arn
}
