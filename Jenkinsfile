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
    
    stage('Build app && push image') {
      steps {
        sh label: '', script: 'ansible-playbook builder.yml --ssh-common-args=\'-o StrictHostKeyChecking=no\''
      }
    }

        stage('Pull image && start app') {
      steps {
        sh label: '', script: 'ansible-playbook builder.yml --ssh-common-args=\'-o StrictHostKeyChecking=no\''
      }
    }

//   stage('Terraform destroy') {
//     steps {
//       sh label: '', script: 'terraform destroy --auto-approve'
//      }
//    }
  }
}