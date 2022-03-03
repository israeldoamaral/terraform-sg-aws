# terraform_aws_vpc
- [x] Status:  Ainda em desenvolvimento.
###
### Módulo para criar um Security Group na AWS. Para utilizar este módulo é necessário os seguintes arquivos especificados logo abaixo:

   <summary>versions.tf - Arquivo com as versões dos providers.</summary>

```hcl
terraform {
    required_version = "~> 0.15.4"

    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 3.0"
        }
    }
 }
```
#
<summary>main.tf - Arquivo que irá consumir o módulo para criar a infraestrutura. Caso você já tenha o arquivo no seu projeto basta copiar e colar o bloco do módulo </summary>

```hcl
provider "aws" {
  region  = var.region
}


module "security_group" {
  source  = "git::https://github.com/israeldoamaral/terraform-sg-aws"
  vpc     = module.network.vpc
  sg-cidr = var.sg-cidr
  # tag-sg  = var.tag-sg
  tag-sg  = "Dev"

}

```
#
<summary>variables.tf - Arquivo que contém as variáveis que o módulo irá utilizar e pode ter os valores alterados de acordo com a necessidade.</summary>

```hcl
variable "sg-cidr" {
  description = "Mapa de portas de serviços"
  # type        = map(object({ protocol = string, action = string, cidr_blocks = string, from_port = number, to_port = number }))
  default = {
    22   = { to_port = 22, description = "Entrada ssh", protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
    80   = { to_port = 80, description = "Entrada http", protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
    443  = { to_port = 443, description = "Entrada https", protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
    8080 = { to_port = 8080, description = "Entrada custom para app", protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
  }
}

```
#
<summary>outputs.tf - Outputs de recursos que serão utilizados em outros módulos.</summary>

```hcl
output "security_Group" {
  description = "Security Group"
  value = module.security_group.security_group_id
}

```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_sg"></a> [sg](#module\_sg) | github.com/israeldoamaral/terraform-sg-aws | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr"></a> [sg-cidr](#input\_sg-cidr) | Mapa de portas de serviços | `map` | `22   = { to_port = 22, description = "Entrada ssh", protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }` | yes |
| <a name="input_tag-sg"></a> [count\_available](#input\_count\_available) | Numero de Zonas de disponibilidade | `number` | `2` | no |
| <a name="input_nacl"></a> [nacl](#input\_nacl) | Regras de Network Acls AWS | `map(object)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Região na AWS, exemplo "us-east-1" | `string` | `" "` | no |
| <a name="input_tag_vpc"></a> [tag\_vpc](#input\_tag\_vpc) | Tag Name da VPC | `string` | `""` | no |

## Outputs

No outputs.
#
## Como usar.
  - Para utilizar localmente crie os arquivos descritos no começo deste tutorial, main.tf, versions.tf, variables.tf e outputs.tf.
  - Após criar os arquivos, atente-se aos valores default das variáveis, pois podem ser alterados de acordo com sua necessidade. 
  - A variável `count_available` define o quantidade de zonas de disponibilidade, públicas e privadas que seram criadas nessa Vpc.
  - Certifique-se que possua as credenciais da AWS - **`AWS_ACCESS_KEY_ID`** e **`AWS_SECRET_ACCESS_KEY`**.

### Comandos
Para consumir os módulos deste repositório é necessário ter o terraform instalado ou utilizar o container do terraform dentro da pasta do seu projeto da seguinte forma:

* `docker run -it --rm -v $PWD:/app -w /app --entrypoint "" hashicorp/terraform:light sh` 
    
Em seguida exporte as credenciais da AWS:

* `export AWS_ACCESS_KEY_ID=sua_access_key_id`
* `export AWS_SECRET_ACCESS_KEY=sua_secret_access_key`
    
Agora é só executar os comandos do terraform:

* `terraform init` - Comando irá baixar todos os modulos e plugins necessários.
* `terraform fmt` - Para verificar e formatar a identação dos arquivos.
* `terraform validate` - Para verificar e validar se o código esta correto.
* `terraform plan` - Para criar um plano de todos os recursos que serão utilizados.
* `terraform apply` - Para aplicar a criação/alteração dos recursos. 
* `terraform destroy` - Para destruir todos os recursos que foram criados pelo terraform. 
