Utilizando ekclt
 - https://eksctl.io/usage/eks-managed-nodes/

Utilizando console aws
- https://us-east-1.console.aws.amazon.com/eks
- https://aws.amazon.com/pt/premiumsupport/knowledge-center/eks-api-server-unauthorized-error/
- https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html

```shell
aws configure
aws sts get-caller-identity
rm -rf ./rm -rf ./.kube/config
aws eks update-kubeconfig --name < NOME_CLUSTER > --region < SUA_REGIAO >
```

Criar os nós

- Entrar no cloud formation
- https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/template

Colocar o script 
- Amazon S3 URL:
- https://amazon-eks.s3-us-west-2.amazonaws.com/cloudformation/2018-12-10/amazon-eks-nodegroup.yaml

Nome Cloud Formation: 
- k8s-ilab-nodes

Nome cluster
- < NOME_CLUSTER >

ClusterControlPlaneSecurityGroup
 - Selecione o criado pelo EKS

NodeGroupName
- < UM NOME QUE VC QUEIRA >

NodeImageId
- https://cloud-images.ubuntu.com/docs/aws/eks/
- ami-00ff481e776f6a0c2

KeyName
- < SUA CHAVE SSH CADASTRADA NA AWS >

Selecione a rede
- VPC
- subnets

Nós criados agora é somente ir no seu console e atrelar os nodes ao seu k8s
```shell
wget https://amazon-eks.s3-us-west-2.amazonaws.com/cloudformation/2018-08-30/aws-auth-cm.yaml
```
No cloudformation criado ir em outputs e copiar o NodeInstanceRole:
- exemplo: arn:aws:iam::473247640396:role/k8s-ilab-nodes-NodeInstanceRole-126RT2GZ42G5X
- https://us-east-1.console.aws.amazon.com/cloudformation/

Depois colar no arquivo baixado:
```yml
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: arn:aws:iam::xxxxxx:role/k8s-nodes-NodeInstanceRole-xxxxxxxxxx
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:node
```
  
Depois rodar no terminal 
```shell
kubectl apply -f aws-auth-cm.yaml