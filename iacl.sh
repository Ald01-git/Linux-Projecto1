#!/bin/bash

# Função para criar diretórios
criar_diretorios() {
  echo "Criando diretórios..."
  mkdir -p /publico /adm /ven /sec || { echo "Erro ao criar diretórios"; exit 1; }
}

# Função para criar grupos
criar_grupos() {
  echo "Criando grupos de usuários..."
  groupadd GRP_ADM || { echo "Erro ao criar grupo GRP_ADM"; exit 1; }
  groupadd GRP_VEN || { echo "Erro ao criar grupo GRP_VEN"; exit 1; }
  groupadd GRP_SEC || { echo "Erro ao criar grupo GRP_SEC"; exit 1; }
}

# Função para criar usuários
criar_usuarios() {
  echo "Criando usuários..."

  declare -A usuarios_grupos=(
    [carlos]=GRP_ADM [maria]=GRP_ADM [joao]=GRP_ADM
    [debora]=GRP_VEN [sebastiana]=GRP_VEN [roberto]=GRP_VEN
    [josefina]=GRP_SEC [amanda]=GRP_SEC [rogerio]=GRP_SEC
  )

  for usuario in "${!usuarios_grupos[@]}"; do
    # Verifica se o usuário já existe
    if id "$usuario" &>/dev/null; then
      echo "Usuário $usuario já existe, pulando..."
    else
      useradd "$usuario" -m -s /bin/bash -G "${usuarios_grupos[$usuario]}" || { echo "Erro ao criar usuário $usuario"; exit 1; }
      echo "$usuario:Senha123" | chpasswd || { echo "Erro ao definir senha para $usuario"; exit 1; }
    fi
  done
}

# Função para definir permissões dos diretórios
definir_permissoes() {
  echo "Especificando permissões dos diretórios..."
  chown root:GRP_ADM /adm || { echo "Erro ao definir proprietário de /adm"; exit 1; }
  chown root:GRP_VEN /ven || { echo "Erro ao definir proprietário de /ven"; exit 1; }
  chown root:GRP_SEC /sec || { echo "Erro ao definir proprietário de /sec"; exit 1; }

  chmod 770 /adm /ven /sec || { echo "Erro ao definir permissões para /adm, /ven ou /sec"; exit 1; }
  chmod 777 /publico || { echo "Erro ao definir permissões para /publico"; exit 1; }
}

# Execução das funções
criar_diretorios
criar_grupos
criar_usuarios
definir_permissoes

echo "Processo concluído!"
