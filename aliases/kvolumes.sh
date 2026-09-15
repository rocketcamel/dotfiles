kubectl -n longhorn-system get volumes.longhorn.io \
  -o custom-columns='VOLUME:.metadata.name,NAMESPACE:.status.kubernetesStatus.namespace,PVC:.status.kubernetesStatus.pvcName,REPLICAS:.spec.numberOfReplicas,HEALTH:.status.robustness'
