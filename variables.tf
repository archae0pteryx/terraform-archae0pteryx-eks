variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "cluster_version" {
  description = "The Kubernetes server version for the EKS cluster."
  type        = string
  default     = "1.28"
}

variable "auth_users" {
  description = "The list of users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "ssh_key_name" {
  description = "The name of the SSH keypair to use for the bastion host."
  type        = string
  default     = "sandbox_key"
}

variable "region" {
  description = "The region in which to create the EKS cluster."
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "The VPC ID in which to create the EKS cluster."
  type        = string
}

variable "vpc_subnet_ids" {
  description = "The subnet IDs in which to create the EKS cluster."
  type        = list(string)
}

variable "vpc_default_security_group_ids" {
  description = "The ID of the default security group for the VPC."
  type        = list(string)
  default     = []
}

variable "vpc_controlplane_subnet_ids" {
  description = "The intra subnet IDs in which to create the EKS cluster."
  type        = list(string)
}

variable "default_tags" {
  description = "The tags to apply to all resources in the module."
  type        = map(string)
  default = {
    Terraform   = "true"
    Environment = "sandbox"
  }
}

variable "node_instance_types" {
  description = "The instance types for the default node group."
  type        = list(string)
  default     = ["t3.medium", "t2.medium", "m6a.large"]
}

variable "node_min_size" {
  description = "The minimum number of nodes."
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "The maximum number of nodes."
  type        = number
  default     = 3
}

variable "node_desired_size" {
  description = "The desired number of nodes."
  type        = number
  default     = 1
}

variable "enable_gpu_nodes" {
  description = "Whether to enable GPU nodes."
  type        = bool
  default     = false
}

variable "gpu_node_instance_types" {
  description = "The instance types for the default GPU node group."
  type        = list(string)
  default     = ["g4dn.xlarge"]
}

variable "gpu_min_nodes" {
  description = "The minimum number of GPU nodes."
  type        = number
  default     = 0
}

variable "gpu_max_nodes" {
  description = "The maximum number of GPU nodes."
  type        = number
  default     = 3
}

variable "gpu_desired_nodes" {
  description = "The desired number of GPU nodes."
  type        = number
  default     = 0
}

variable "karpenter_enable" {
  description = "Whether to enable Karpenter."
  type        = bool
  default     = false
}

variable "karpenter_role_arn" {
  description = "The ARN of the IAM role for Karpenter."
  type        = string
  default     = ""
}

variable "enable_monitoring" {
  description = "Whether to enable monitoring."
  type        = bool
  default     = false
}
