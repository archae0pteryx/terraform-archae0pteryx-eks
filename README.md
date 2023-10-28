## EKS Mixed cluster for AI pipelines and applications

Bare bones mixed GPU eks cluster.
- Managed node groups
- Default no schedule taints for GPU nodes
- Karpenter annotations

#### Inputs
```hcl
cluster_name
cluster_version
auth_users
ssh_key_name
region
vpc_id
vpc_subnet_ids
vpc_default_security_group_ids
vpc_controlplane_subnet_ids
node_instance_types
node_min_size
node_max_size
node_desired_size
enable_gpu_nodes
gpu_node_instance_types
gpu_min_nodes
gpu_max_nodes
gpu_desired_nodes
karpenter_enable
karpenter_role_arn
enable_monitoring
default_tags
```

#### Outputs
```hcl
cluster_name
cluster_endpoint
cluster_certificate_authority_data
cluster_oidc_provider_arn
```
