pipeline {
  agent any
  tools {
//      terraform "tf_local"
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

    stage('Terraform destroy') {
      timeout(time: 2, unit: 'MINUTES')}
      {
      steps {
        sh label: '', script: 'terraform destroy --auto-approve'
      }
    }
  }
}