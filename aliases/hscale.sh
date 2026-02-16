kubectl exec -n networking -it "$(kubectl get pod -n networking -l app=headscale -o jsonpath='{.items[0].metadata.name}')" -- headscale "$@"
