output "cluster_names" {
  value = [for c in kind_cluster.this : c.name]
}

output "kubeconfig_paths" {
  value = { for k, c in kind_cluster.this : k => c.kubeconfig_path }
}