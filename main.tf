locals {
  remote_access = {
    ec2_ssh_key               = var.ssh_key_name
    source_security_group_ids = [aws_security_group.remote_access.id]
  }
  default_node_group = {
    default_eks_nodes = {
      capacity_type  = "ON_DEMAND"
      instance_types = var.node_instance_types
      min_size       = var.node_min_size
      max_size       = var.node_max_size
      desired_size   = var.node_desired_size
    }
  }
  gpu_node_group = var.enable_gpu_nodes ? {
    gpu_eks_nodes = {
      instance_types = var.gpu_node_instance_types
      capacity_type  = "SPOT"
      min_size       = var.gpu_min_nodes
      max_size       = var.gpu_max_nodes
      desired_size   = var.gpu_desired_nodes
      taints = {
        dedicated = {
          key    = "dedicated"
          value  = "gpuGroup"
          effect = "NO_SCHEDULE"
        }
      }
      remote_access = local.remote_access
    }
  } : {}
  merged_node_groups = merge(local.default_node_group, local.gpu_node_group)
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.17.2"

  cluster_name                   = var.cluster_name
  cluster_endpoint_public_access = true

  vpc_id                   = var.vpc_id
  subnet_ids               = var.vpc_subnet_ids
  control_plane_subnet_ids = var.vpc_controlplane_subnet_ids

  create_aws_auth_configmap = true
  manage_aws_auth_configmap = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  aws_auth_users = var.auth_users
  aws_auth_roles = [
    # We need to add in the Karpenter node IAM role for nodes launched by Karpenter
    {
      rolearn  = var.karpenter_role_arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups = [
        "system:bootstrappers",
        "system:nodes",
      ]
    },
  ]

  eks_managed_node_groups = local.merged_node_groups

  tags = merge(var.default_tags, {
    "karpenter.sh/discovery" = var.cluster_name
  })
}

resource "aws_security_group" "remote_access" {
  name_prefix = "${var.cluster_name}-remote-access"
  description = "Allow remote SSH access"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = var.default_tags
}
