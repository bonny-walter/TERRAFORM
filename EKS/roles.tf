# create an iam role to be attached to the following policies: AmazonEKSClusterPolicy ,AmazonEKSServicePolicy
resource "aws_iam_role" "eks-cluster-role" {
  name = "eks-cluster-role"

  assume_role_policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "eks.amazonaws.com"
        },
        "Sid": ""
      }
    ]
  }
POLICY

}

resource "aws_iam_role_policy_attachment" "eks-policy-cluster-attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster-role.name
}

resource "aws_iam_role_policy_attachment" "eks-policy-cluster-attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks-cluster-role.name
}

# for the workers nodes,we must create an iam role to attach to: AmazonEKSWorkerNodePolicy, AmazonEKS_CNI_Policy, AmazonEC2ContainerRegistryReadOnly
resource "aws_iam_role" "eks-worker-role" {
  name = "eks-worker-role"

  assume_role_policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Sid": ""
      }
    ]
  }
POLICY

}


resource "aws_iam_role_policy_attachment" "worker-node-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-worker-role.name
}


resource "aws_iam_role_policy_attachment" "worker-node-cni" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-worker-role.name
}


resource "aws_iam_role_policy_attachment" "worker-node-ecr" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-worker-role.name
}

resource "aws_iam_instance_profile" "worker-node-profile" {
  name = "eks-worker-node-profile"
  role = aws_iam_role.eks-worker-role.name
}


