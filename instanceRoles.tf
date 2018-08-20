resource "aws_iam_role" "ec2role" {
    name = "ec2role-iam-role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "s3read" {
    name = "s3read-iam-role-policy"
    role = "${aws_iam_role.ec2role.id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::awssa-demo/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "EC2RoleProfile" {
    name = "EC2RoleProfile-iam-instance-profile"
    role = "${aws_iam_role.ec2role.id}"
}
