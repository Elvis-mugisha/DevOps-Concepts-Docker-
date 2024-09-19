
pipeline {
    agent any

      environment {
           MAVEN_HOME = tool 'maven' // Ensure Maven is configured in Jenkins (Global Tool Configuration)
           DOCKER_CREDENTIALS_ID = '7878' // Update with the correct credentials ID for Docker
           DOCKER_IMAGE = 'elvis054/demo'
           DOCKER_REGISTRY = 'docker.io'
       }


    stages {
        // Build Stage
        stage('Build') {
            steps {
                echo 'Building the project...'
                script {
                    def mvnCmd = "${MAVEN_HOME}\\bin\\mvn.cmd"
                    bat "${mvnCmd} clean install"
                }
            }
        }

        // Test Stage
        stage('Test') {
            steps {
                echo 'Running tests...'
                script {
                    def mvnCmd = "${MAVEN_HOME}\\bin\\mvn.cmd"
                    bat "${mvnCmd} test"
                }
            }
        }

        // Build Docker Image Stage
        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                script {
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        bat 'docker build -t %DOCKER_IMAGE%:latest .'
                    }
                }
            }
        }

// Push Docker Image Stage
stage('Push Docker Image') {
    steps {
        echo 'Pushing Docker image...'
        script {
            withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                // Debug output for Docker username and password
                bat 'echo %DOCKER_USERNAME%'
                bat 'echo %DOCKER_PASSWORD% | docker login -u %DOCKER_USERNAME% --password-stdin'

                // Tag and push Docker image
                bat 'docker tag %DOCKER_IMAGE%:latest %DOCKER_REGISTRY%/%DOCKER_IMAGE%:latest'
                bat 'docker push %DOCKER_REGISTRY%/%DOCKER_IMAGE%:latest'
            }
        }
    }
}


        // Deploy Docker Image Stage
        stage('Deploy Docker Image') {
            steps {
                echo 'Deploying Docker image...'
                script {
                    bat 'docker pull %DOCKER_IMAGE%:latest'
                    bat 'docker run -d -p 8081:8080 %DOCKER_IMAGE%:latest'
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace...'
            cleanWs() // Clean up the workspace
        }
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}