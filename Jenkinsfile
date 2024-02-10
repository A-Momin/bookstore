pipeline{
    agent any
    stages {
    
        stage('Setup Python Virtual ENV'){
            steps  {
                sh '''
                chmod +x scripts/envsetup.sh
                ./scripts/envsetup.sh
                '''
            }
        }
        stage('Setup Gunicorn Setup'){
            steps {
                sh '''
                chmod +x scripts/gunicorn.sh
                ./scripts/gunicorn.sh
                '''
            }
        }
        stage('setup NGINX'){
            steps {
                sh '''
                chmod +x scripts/nginx.sh
                ./scripts/nginx.sh
                '''
            }
        }
    }
}