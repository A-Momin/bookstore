pipeline {
    //agent any
    agent {
        // Use a Docker agent with the host's Docker daemon
        docker {
            // Use the same Docker daemon as the host
            reuseNode true
        }
    }

    environment {
        DJANGO_SETTINGS_MODULE = 'core.settings'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // 'your-github-credentials-id': Specifies the credentials ID to be used for authenticating with the Git repository. This ID corresponds to the credentials stored in Jenkins that contain the necessary authentication information, such as username and password or token.
                    git branch: 'main',  credentialsId: 'your-github-credentials-id', url: 'https://github.com/A-Momin/bookstore.git'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Define the Docker image name and tag
                    def dockerImage = "your-docker-repo/your-docker-image:latest"

                    // Build the Docker image from the Dockerfile in the root directory
                    sh "docker build -t ${dockerImage} ."

                    // Push the Docker image to a container registry (optional)
                    sh "docker push ${dockerImage}"
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'pip install -r requirements.txt'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'python manage.py test'
            }
        }

        stage('Deploy') {
            steps {
                // Add deployment steps if applicable
            }
        }
    }

/*
    // Ensure that the "Email Extension Plugin" is installed in your Jenkins instance.
    // You may need to configure the email notification settings in Jenkins under "Manage Jenkins" > "Configure System" > "Extended E-mail Notification."
    post {
        always {
            emailext subject: "Pipeline Status: ${currentBuild.result}",
                      body: "The Jenkins pipeline has completed. Status: ${currentBuild.result}",
                      to: "AMominNJ@gmail.com",
                      attachLog: true,
                      recipientProviders: [[$class: 'DevelopersRecipientProvider']]
        }
    }
*/

/*
    post {
        failure {
            emailext body: '''${SCRIPT, template="groovy-html.template"}''', 
                    subject: "${env.JOB_NAME} - Build # ${env.BUILD_NUMBER} - Failed", 
                    mimeType: 'text/html',to: "bbcredcap3@gmail.com"
            }
         success {
               emailext body: '''${SCRIPT, template="groovy-html.template"}''', 
                    subject: "${env.JOB_NAME} - Build # ${env.BUILD_NUMBER} - Successful", 
                    mimeType: 'text/html',to: "bbcredcap3@gmail.com"
          }      
    }
*/

}
