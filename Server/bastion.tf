#--------------------------------------------------------------
# Bastion Artifact (AMI)
#--------------------------------------------------------------
data "atlas_artifact" "SonarBastion" {
	name       = "Panda/SonarBastion"
	version    = "latest"
	type       = "amazon.image"
}

#--------------------------------------------------------------
# Bastion Host
#--------------------------------------------------------------
resource "aws_instance" "BastionInstance" {
	ami               = "${data.atlas_artifact.SonarBastion.metadata_full.region-us-east-1}"
	instance_type     = "t1.micro"
	subnet_id         = "${aws_subnet.sonar_public_subnet.1.id}"
	security_groups   = ["${aws_security_group.primary.id}", "${aws_security_group.bastion.id}","${aws_security_group.consul_security_group.id}"]
	depends_on        = ["aws_internet_gateway.sonar_gateway", "aws_key_pair.SonarKey", "aws_instance.Consul-Server"]
	key_name          = "${aws_key_pair.SonarKey.key_name}"
	monitoring        = true
	source_dest_check = false

	connection {
		user     = "ubuntu"
		key_file = "${var.key_file}"
	}

	tags {
		Name       = "BastionInstance"
		role       = "bastion"
		monitoring = "consul"
	}

	lifecycle {
		create_before_destroy = true
	}
}

#--------------------------------------------------------------
# Bastion EIP
#--------------------------------------------------------------
resource "aws_eip" "BastionEip" {
	instance = "${aws_instance.BastionInstance.id}"
	vpc      = true

	lifecycle {
		create_before_destroy = true
	}
}