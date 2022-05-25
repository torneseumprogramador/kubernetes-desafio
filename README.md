
# Decobrindo o IP do cluster
```shell
kubectl get nodes -o wide
```
# cria um pod com uma imagem docker
```shell
kubectl run didox-nginx --image=nginx:latest  
```

# Lista o pod e mostra o IP local
```shell
kubectl get pods -o wide 
```

# Acompanha em modo watch a criação do pod
```shell
kubectl get pods --watch 
```

# Apaga o pop criado
```shell
kubectl delete pods didox-nginx 
```

# Descreve o pod
```shell
kubectl describe pod  didox-nginx 
```

# Acessa o pod via ssh methodo deprecated
```shell
kubectl exec -it didox-nginx bash 
```

# Acessa o pod via ssh 
```shell
kubectl exec --stdin --tty didox-nginx -- /bin/bash 
kubectl exec --stdin --tty didox-nginx -- /bin/sh 
```

# Edita pod
```shell
kubectl edit pod didox-nginx
```

# apaga todos os pods
```shell
kubectl delete pods --all 
```

# apaga todos os servicos
```shell
kubectl delete services --all 
```

# valida yml
```shell
npm install -g yaml-lint
sudo apt install npm
npx yaml-lint yamllint pod.yml

```


```shell

# $ kubectl apply -f deployment-nodejs.yml
# $ kubectl describe -f deployment-nodejs.yml
# $ kubectl delete -f deployment-nodejs.yml
# $ kubectl logs -l app=lable-pod-nodejs # log de todos os lables do replicaset
# $ kubectl logs --tail=20 --follow=true -l app=lable-pod-nodejs
# $ kubectl rollout history deployment
# $ kubectl annotate deployment.apps/nodejs-deployment kubernetes.io/change-cause="levantando mudando a variavel de ambiente"
# $ kubectl rollout undo deployment.apps/nodejs-deployment --to-revision=2
# $ kubectl scale deployment.v1.apps/nodejs-deployment --replicas=2

# $ kubectl autoscale deployment.v1.apps/nodejs-deployment --min=2 --max=5 --cpu-percent=80


# $ kubectl get pod -o yaml > teste.yml # exportando yaml do pod do kubernets


# $ kubectl apply -f deployment-site.yaml
# $ kubectl delete -f deployment-site.yaml
# $ kubectl get deployment
# $ kubectl describe deployment site-deployment
# $ kubectl rollout history deployment site-deployment
# $ kubectl annotate deployment.v1.apps/site-deployment kubernetes.io/change-cause="teste de comentário"
# $ kubectl rollout undo deployment.v1.apps/site-deployment --to-revision=2
# $ kubectl get rs
# $ kubectl get rs -w
# $ kubectl get pods -o wide # w = watch para acompanhar a criação
# $ kubectl get pods -o wide -w # w = watch para acompanhar a criação
# $ kubectl scale deployment.v1.apps/site-deployment --replicas=2
# $ kubectl autoscale deployment.v1.apps/site-deployment --min=5 --max=8 --cpu-percent=80
# $ kubectl get hpa # mostra status autoscale
# $ kubectl delete hpa site-deployment
# $ kubectl delete horizontalpodautoscaler --all
# $ kubectl set image deployment.v1.apps/site-deployment nginx=nginx:latest
# $ kubectl run didox-nginx-memoria --image=nginx --requests=cpu=500m,memory=500M --expose --port=80
# $ kubectl autoscale deployment didox-nginx-memoria --cpu-percent=50 --min=1 --max=10
# $ kubectl get namespaces # verificar os namespaces disponíveis
# $ kubectl create namespace bancodedados # cria namespaces para organizar seus pods e recursos
# $ kubectl get pods -n bancodedados # lista recursos do namespace
# $ kubectl get endpoints # mostra todos os serviços disponíveis no kubernetes
# $ kubectl exec -it nodejs-deployment-6fd74b494d-d5xm8 -- bash # entra dentro do meu POD
# $ kubectl exec -it nodejs-deployment-6fd74b494d-d5xm8 -- apk add bash # starta container e entra no bash
# $ kubectl get hpa # mostra a quantidade de máquinas que tenho no replicaset autoscale

```

# Service exterrnal name to connect pod on RDS
https://medium.com/@ManagedKube/kubernetes-access-external-services-e4fd643e5097
https://kubernetes.io/docs/concepts/services-networking/service/
https://www.magalix.com/blog/kubernetes-services-101-the-pods-interfaces