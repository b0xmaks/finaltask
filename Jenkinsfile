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

    stage('Build and push image with Ansible') {
      steps {
        sh label: '', script: 'ansible-playbook -i '${yandex_compute_instance.vm-1.network_interface.0.nat_ip_address}', builder.yml'
      }
    }

    stage('Terraform destroy') {
      steps {
        sh label: '', script: 'terraform destroy --auto-approve'
      }
    }
  }
}