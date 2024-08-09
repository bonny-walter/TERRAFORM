# cluster resource
resource "aws_eks_cluster" "eks-cluster" {
    name = "my-eks-cluster-001"
    role_arn = aws_iam_role.eks-cluster-role.arn

    vpc_config {
        security_group_ids = [aws_security_group.eks-cluster-sg.id]
        subnet_ids = aws_subnet.eks-node-subnet.*.id
    }
}

# node group resource
resource "aws_eks_node_group" "eks-cluster-node-group" {
    cluster_name = aws_eks_cluster.eks-cluster.name
    node_group_name = "nodegroup-01"
    node_role_arn = aws_iam_role.eks-worker-role.arn 
    subnet_ids =  aws_subnet.eks-node-subnet.*.id

    scaling_config {
        desired_size = 3
        max_size = 4
        min_size = 3
    }

    update_config {
        max_unavailable = 1
    }
}

# aws eks update-kubeconfig --region us-east-2 --name my-eks-cluster-001
