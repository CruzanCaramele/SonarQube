#--------------------------------------------------------------
# Primary Security Group
#--------------------------------------------------------------
resource "aws_security_group" "primary" {
	name        = "primary-sonar-security"
	description = "Default security group that allows inbound and outbound traffic from all instances in the VPC"
	vpc_id      = "${aws_vpc.sonar_vpc.id}"

	ingress {
		from_port = "0"
		to_port   = "0"
		protocol  = "-1"
		self      = true
	}

	egress {
		from_port   = "0"
		to_port     = "0"
		protocol    = "-1"
		self        = true
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags {
		Name = "sonar-default-vpc"
	} 
}

#--------------------------------------------------------------
# bastion Server Security Group
#--------------------------------------------------------------
resource "aws_security_group" "bastion" {
	name        = "bastion-sonar"
	description = 
}