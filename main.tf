##
# Module to setup confluent platform instances on Google Cloud
##

module "confluent-platform-network" {
  source = "./modules/confluent-platform-network"
  name = var.name
  project = var.project
  credentials_file = var.credentials_file
  region = var.region
  zone   = var.zone
}

module "confluent-cluster" {
  source = "./modules/confluent-platform"
  brokers = var.brokers
  zookeepers = var.zookeepers
  control-centre = var.control-centre
  schema-registrys = var.schema-registrys
  connects = var.connects

  vpc_network_name = module.google_confluent_kafka_network.vpc_net_name

  name = var.name
  project = var.project
  credentials_file = var.credentials_file
  myip = var.myip

  region = var.region
  zones = var.zones

  owner_email = var.owner_email
  owner_name = var.owner_name

  gce_ssh_pub_key_file = var.ssh_pub_key
}

module "confluent-platform-control-center" {
  source = "./modules/confluent-platform-control-center"

  name = var.name
  project = var.project
  credentials_file = var.credentials_file
  myip = var.myip

  vpc_network_name = module.confluent-platform-network.vpc_net_name
  dns_zone = module.confluent-cluster.dns_zone

  region = var.region
  zone   = var.zone

  owner_email = var.owner_email
  owner_name = var.owner_name

  gce_ssh_pub_key_file = var.ssh_pub_key

}
