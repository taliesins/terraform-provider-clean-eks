resource "eks_clean_job" "cluster" {
  endpoint    = data.aws_eks_cluster.cluster.endpoint
  ca_cert_pem = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token       = data.aws_eks_cluster_auth.cluster.token

  remove_aws_cni         = true
  remove_kube_proxy      = true
  import_coredns_to_helm = true
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"

  enable_cluster_creator_admin_permissions = true # if this is disabled then the deployment user cannot work inside kubernetes cluster
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}
