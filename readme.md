# DevOps Internship Capstone Project
Whole project consists of three repositories:
- Pre-setup (this repo)
- [Continous Integration repository](https://github.com/lipalipinski/capstone-project-2-ci-cd)
- [Petclinic application repository](https://github.com/lipalipinski/spring-petclinic)
# Pre-setup Repository

This repo contains configuration-as-code for a Petclinic app CI/CD solution. 
It uses Terraform for provisioning infrastructure in AWS cloud. Before the first run it needs some basic manual configuration:
- installing and configuring AWS CLI locally
- setting an AWS Region in `variables.tf`
- setting Terraform backend S3 and Dynamo-DB config in `providers.tf`
- providing ssh keys for for servers in files/secrets (there is a script `files/generate-keys.sh` which can generate keys using ssh-keygen and store them in a location proovided with `$1` argument)
- providing github token which allows Jenkins Githubb Plugin to connect with Petclinic repo (`files/secrets/ght-token`)
- building AWS EC2 AMIs for Jenkins controller, Jenkins worker and Application server with Packer (`packer` directory)

Application build and deployment, as well as provisioning app server, ALB and database could be done from Jenkins with jobs configured in [CICD Repo](https://github.com/lipalipinski/capstone-project-2-ci-cd).

### Full application deployment
![AWS resources schema](petclinic-aws.svg)

### Resources provisioned with this repo
![AWS resources schema](petclinic-pre-setup.svg)

## Security Groups

### jenkins-controller-sg
|     | protocol | port | source/dest |
| --- | --- | --- | --- |
| Inbound | TCP | 22 | EC2 Connect IP range |
| Inbound | TCP | 80 | 0.0.0.0/0 |
| Outbound | All | All | 0.0.0.0/0 |

### jenkins-worker-sg
|     | protocol | port | source/dest |
| --- | --- | --- | --- |
| Inbound | TCP | 22 | jenkins-controller-sg |
| Outbound | All | All | 0.0.0.0/0 |

### app-lb-sg
|     | protocol | port | source/dest |
| --- | --- | --- | --- |
| Inbound | TCP | 80 | 0.0.0.0/0 |
| Outbound | All | All | 0.0.0.0/0 |

### app-server-sg
|     | protocol | port | source/dest |
| --- | --- | --- | --- |
| Inbound | TCP | 22 | jenkins-worker-sg |
| Inbound | TCP | 80 | app-lb-sg |
| Inbound | TCP | 80 | jenkins-worker-sg |
| Inbound | TCP | 8080 | jenkins-worker-sg |
| Outbound | All | All | 0.0.0.0/0 |

### db-sg
|     | protocol | port | source/dest |
| --- | --- | --- | --- |
| Inbound | TCP | 3306 | app-server-sg |