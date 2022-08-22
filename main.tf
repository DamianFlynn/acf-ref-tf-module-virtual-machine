# Solution Template.
#

module "payload" {
  source = "./modules/payload"

  name           = var.name
  location       = var.location
  tags           = var.tags
  subscriptionId = var.subscriptionId
}
