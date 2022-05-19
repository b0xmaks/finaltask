pipeline {
  agent any
  tools {
//      terraform "tf_local"
      terraform "tf"
      ansible "Ans"
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
//      options {
//                timeout(time: 600, unit: "SECONDS")
//      }      
      steps {
        ansiblePlaybook becomeUser: null, colorized: true, disableHostKeyChecking: true, playbook: 'builder.yml', sudoUser: null, vaultCredentialsId: 'id_rsa_private'
      }
    }

    stage('Pull image && start app') {
//      options {
//                timeout(time: 300, unit: "SECONDS")
//      }          
      steps {
        ansiblePlaybook becomeUser: null, colorized: true, disableHostKeyChecking: true, playbook: 'stage.yml', sudoUser: null, vaultCredentialsId: 'id_rsa_private'
      }
    }

//   stage('Terraform destroy') {
//     steps {
//       sh label: '', script: 'terraform destroy --auto-approve'
//      }
//    }
  }
}