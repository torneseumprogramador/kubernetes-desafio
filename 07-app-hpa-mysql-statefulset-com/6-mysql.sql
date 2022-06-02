/*
no control plane rodar o comando para entrar no mysql pod
$ kubectl exec -it mysqlstatefulset-0 bin/bash
depois no container rodar o seguinte comando
$ mysql -uroot -p'root'
rodar o comando abaixo
*/

use db_k8s_desafio;
insert into administradores(email, senha, nome)values('danilo@gmail.com', '123456', 'Danilo');

/*
Feito isso, somete se logar no sistema com o usuário e senha
*/