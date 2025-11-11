def img
pipeline {
    environment {
        registry = "bbcredcap3/bookstore"
        registryCredential = 'docker-hub-cred' // Credentials for Jenkins to login your Docker-Hub account.
        dockerImage = ''
    }

    agent {
        label 'main-agent'
    }

    stages {
        stage('checkout') {
            steps {
                git 'https://github.com/A-Momin/bookstore.git'
                // alternatively approch:
                // checkout scm // The url is provided during pipeline creation
            }
        }

        // stage ('Stop previous running container'){
        //     steps{
        //         sh returnStatus: true, script: 'docker stop $(docker ps -a | grep ${JOB_NAME} | awk \'{print $1}\')'
        //         sh returnStatus: true, script: 'docker rmi $(docker images | grep ${registry} | awk \'{print $3}\') --force' //this will delete all images
        //         sh returnStatus: true, script: 'docker rm ${JOB_NAME}'
        //     }
        // }


        stage('Build Image') {
            steps {
                script {
                    img = registry + ":${env.BUILD_ID}"
                    println ("${img}")
                    dockerImage = docker.build("${img}")
                }
            }
        }



        stage('Test - Run Docker Container on Specified Agent') {
           steps {
                // `JOB_NAME` --> The name you give at the job creation through Jenkins Web UI.
                sh label: '', script: "docker run -d --name ${JOB_NAME} -p 8000:8000 ${img}"
          }
        }

        stage('Push To DockerHub') {
            steps {
                script {
                    docker.withRegistry( 'https://registry.hub.docker.com ', registryCredential ) {
                        dockerImage.push()
                    }
                }
            }
        }

        stage('Deploy to Test Server') {
            steps {
                script {
                    def remoteserver = "192.168.1.16"
                    def stopcontainer = "docker stop ${JOB_NAME}"
                    def delcontName = "docker rm ${JOB_NAME}"
                    def delimages = 'docker image prune -a --force'
                    def drun = "docker run -d --name ${JOB_NAME} -p 5000:5000 ${img}"
                    println "${drun}"
                    
                    // "master-agent" is the ID of SSH Credentials from Jenkins master to this remote server.
                    sshagent(['master-agent']) {
                        sh returnStatus: true, script: "ssh -o StrictHostKeyChecking=no docker@${remoteserver} ${stopcontainer} "
                        sh returnStatus: true, script: "ssh -o StrictHostKeyChecking=no docker@${remoteserver} ${delcontName}"
                        sh returnStatus: true, script: "ssh -o StrictHostKeyChecking=no docker@${remoteserver} ${delimages}"

                    // some block
                        sh "ssh -o StrictHostKeyChecking=no docker@${remoteserver} ${drun}"
                    }
                }
            }
        }
    }
}