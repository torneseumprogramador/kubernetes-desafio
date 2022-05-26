
cd ../0-terraform

ID_M1_DNS=$(terraform output | grep 'master -' | awk '{print $3;exit}' | cut -d'"' -f 1)

ID_W1_DNS=$(terraform output | grep 'worker 1 -' | awk '{print $4;exit}' | cut -d'"' -f 1)
ID_W2_DNS=$(terraform output | grep 'worker 2 -' | awk '{print $4;exit}' | cut -d'"' -f 1)
ID_W3_DNS=$(terraform output | grep 'worker 3 -' | awk '{print $4;exit}' | cut -d'"' -f 1)

cd ../1-ansible

echo "
[k8s-master]
$ID_M1_DNS

[k8s-node-1]
$ID_W1_DNS

[k8s-node-2]
$ID_W2_DNS

[k8s-node-3]
$ID_W3_DNS

" > hosts

ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts provisionar.yml -u ubuntu --private-key ~/Desktop/desafio_devops/chaves_desafio_kubernetes/id_rsa

