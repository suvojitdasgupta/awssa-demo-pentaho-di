provider "aws" {}

resource "aws_instance" "main" {
    ami = "${var.base_ami}"
    instance_type = "${var.instance_type}"
    iam_instance_profile = "${aws_iam_instance_profile.EC2RoleProfile.name}"
    user_data = "${file("userdata.yml")}"
    key_name = "${var.ssh_key_name}"
    subnet_id = "${var.internal_subnet_id}"
    associate_public_ip_address = true 
    source_dest_check = true
    count = "${var.server_count}"
    tags {
        Name = "${var.tagName}-${count.index}"
        "EOD_TERMINATE_FLAG" = "Y"
    }

    ebs_block_device {
        device_name = "sdc"
        volume_type = "gp2"
        volume_size = 200
        delete_on_termination = true
        encrypted = true
    }

    connection {
       user = "ec2-user"
       private_key="${file("PEM_FILE_NAME")}"
       agent = true
       timeout = "3m"
    } 

    provisioner "remote-exec" {
        inline = [
        "sudo yum -y install git",
        "sudo yum -y install aws-cli",
        "mkdir -p /home/ec2-user/projects/awssa-demo-pentaho-di",
        "mkdir -p /home/ec2-user/data/input",
        "mkdir -p /home/ec2-user/data/interim",
        "mkdir -p /home/ec2-user/data/output",
        "mkdir -p /home/ec2-user/data/error", 
        "mkdir -p /home/ec2-user/data/logs",
        "mkdir -p /home/ec2-user/pentaho/pdi/",
        "curl -Lo /home/ec2-user/pentaho/pdi/pdi-ce-8.0.0.0-28.zip -O https://sourceforge.net/projects/pentaho/files/Pentaho%208.0/client-tools/pdi-ce-8.0.0.0-28.zip",
        "unzip /home/ec2-user/pentaho/pdi/pdi-ce-8.0.0.0-28.zip -d /home/ec2-user/pentaho/pdi/pdi-ce-8.0.0.0-28",
        "ln -s /home/ec2-user/pentaho/pdi/pdi-ce-8.0.0.0-28 /home/ec2-user/pentaho/pdi/current",
        "git clone git@github.com:suvojitdasgupta/CODE_REPO_NAME.git /home/ec2-user/projects/CODE_REPO_NAME/",
        "chmod -R 777 /home/ec2-user/pentaho",
        "chmod -R 777 /home/ec2-user/projects",
        "chmod -R 777 /home/ec2-user/data"
      ]
    }
}
