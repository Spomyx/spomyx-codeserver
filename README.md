# spomyx-codeserver

To Generate secrets containing private key for authentication to github and cert to communicate with Kubernetes API:

```yaml
kubectl create secret generic github-login-key --from-file=./github_private_key.key
```