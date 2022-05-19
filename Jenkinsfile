pipeline {
  agent any
  tools {
      terraform "tf"
  }
  stages {

    stage('Terraform Init') {
      steps {
        sh label: '', script: 'terraform init'
      }
    }
    
    stage('Terraform apply') {
      steps {
        sh label: '', script: 'terraform apply --auto-approve'
      }
    }
    
    stage('Build app && push image') {
      steps {
        ansiblePlaybook become: true, colorized: true, credentialsId: 'jenkins-ubuntu-privat', disableHostKeyChecking: true, installation: 'ans', playbook: 'builder.yml', vaultCredentialsId: 'jenkins_id_rsa'
      }
    }

    stage('Pull image && start app') {
      steps {
        ansiblePlaybook become: true, colorized: true, credentialsId: 'jenkins-ubuntu-privat', disableHostKeyChecking: true, installation: 'ans', playbook: 'stage.yml', vaultCredentialsId: 'jenkins_id_rsa'
      }
    }
  }
}