pipeline {
    agent any 
    stages {
        stage ('Clean Workspace') {
            steps {
                script{
                    remote = [:]
                    remote.name = "ubuntu"
                    remote.host = params.IP_ADDRESS
                    remote.allowAnyHosts = true
                    remote.failOnError = true
                    withCredentials([usernamePassword(credentialsId: 'user-cred', passwordVariable: 'password', usernameVariable: 'username')]) {
                        remote.user = params.LINUX_USER
                        remote.password = params.LINUX_PASS
                        sshCommand remote: remote, command: "sudo rm -rf /tmp/local-deployment || true"
                    }
                }
           }
        }
        stage ('Clone Repository') {
            steps {
                script{
                    remote = [:]
                    remote.name = "ubuntu"
                    remote.host = params.IP_ADDRESS
                    remote.allowAnyHosts = true
                    remote.failOnError = true
                    withCredentials([usernamePassword(credentialsId: 'user-cred', passwordVariable: 'password', usernameVariable: 'username')]) {
                        remote.user = params.LINUX_USER
                        remote.password = params.LINUX_PASS
                        sshCommand remote: remote, command: "cd /tmp && git clone https://github.com/virtapp/local-deployment.git"
                    }
                }
           }
        }
        stage ('Install App') {
            steps {
                script{
                    remote = [:]
                    remote.name = "ubuntu"
                    remote.host = params.IP_ADDRESS
                    remote.allowAnyHosts = true
                    remote.failOnError = true
                    withCredentials([usernamePassword(credentialsId: 'user-cred', passwordVariable: 'password', usernameVariable: 'username')]) {
                        remote.user = params.LINUX_USER
                        remote.password = params.LINUX_PASS
                        sshCommand remote: remote, command: "cd /tmp/local-deployment/ && bash install.sh"
                    }
                }
           }
        }
        stage ('Get Ingress') {
            steps {
                script{
                    remote = [:]
                    remote.name = "ubuntu"
                    remote.host = params.IP_ADDRESS
                    remote.allowAnyHosts = true
                    remote.failOnError = true
                    withCredentials([usernamePassword(credentialsId: 'user-cred', passwordVariable: 'password', usernameVariable: 'username')]) {
                        remote.user = params.LINUX_USER
                        remote.password = params.LINUX_PASS
                        sshCommand remote: remote, command: "sudo kubectl get svc -A"
                    }
                }
           }
        }
    }
}
