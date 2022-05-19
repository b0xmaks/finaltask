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
      options {
                timeout(time: 600, unit: "SECONDS")
      }      
      steps {
        sh label: '', script: 'ansible-playbook builder.yml'
      }
    }

    stage('Pull image && start app') {
      options {
                timeout(time: 300, unit: "SECONDS")
      }          
      steps {
        sh label: '', script: 'ansible-playbook stage.yml'
      }
    }

//   stage('Terraform destroy') {
//     steps {
//       sh label: '', script: 'terraform destroy --auto-approve'
//      }
//    }
  }
}