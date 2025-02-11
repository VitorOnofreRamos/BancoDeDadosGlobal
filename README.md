# Banco de Dados do Sistema de Análise e Monitoramento de Usinas Nucleares (S.A.M.E.N)

## Visão Geral
Este repositório contém os scripts necessários para a criação e configuração do banco de dados Oracle utilizado pelo projeto [S.A.M.E.N](https://github.com/VitorOnofreRamos/Global-Solution-ADB). Os scripts incluem a definição das tabelas, procedures, funções e demais objetos de banco de dados essenciais para o funcionamento do sistema de monitoramento de usinas nucleares.

## Pré-requisitos
- Oracle Database instalado e configurado.
- Acesso a uma ferramenta de administração de banco de dados, SQL Developer ou outra de sua preferência.

## Instruções de Instalação
1. **Clone o Repositório e abra o diretório:**
```bash
git clone https://github.com/VitorOnofreRamos/BancoDeDadosGlobal.git
cd BancoDeDadosGlobal
```
2. **Conecte-se ao Banco de Dados Oracle:** Utilize sua ferramenta de administração preferida para conectar-se ao seu banco de dados Oracle.

3. **Execute os Scripts de Criação de Tabelas:** Navegue até o diretório `/scripts` e execute os scripts SQL na seguinte ordem:

- `create_tables.sql`: Cria as tabelas necessárias para o sistema.
- `insert_initial_data.sql`: Insere os dados iniciais nas tabelas.

## Observações
- Certifique-se de que os nomes dos objetos (tabelas, procedures, etc.) não conflitem com objetos já existentes no seu esquema do Oracle Database.
- Revise os scripts antes da execução para garantir que estejam alinhados com a configuração específica do seu ambiente.
- Após a instalação, é recomendável realizar testes para assegurar que todas as procedures e funções estejam operando conforme esperado.

Contato
Para dúvidas ou suporte, entre em contato através das issues no repositório principal do projeto: [https://github.com/VitorOnofreRamos/Global-Solution-ADB](https://github.com/VitorOnofreRamos/Global-Solution-ADB])
