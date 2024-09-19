pipeline {
    agent any

    environment {
        MAVEN_HOME = tool 'maven' // Ensure Maven is configured in Jenkins (Global Tool Configuration)
        DOCKER_CREDENTIALS_ID = '7878' // Update with the correct credentials ID
        DOCKER_IMAGE = 'elvis054/demo'
        DOCKER_REGISTRY = 'docker.io'
    }


        // Build Stage
        stage('Build') {
            steps {
                echo 'Building the project...'
                script {
                    sh "${MAVEN_HOME}/bin/mvn clean install"
                }
            }
        }

        // Test Stage
        stage('Test') {
            steps {
                echo 'Running tests...'
                script {
                    sh "${MAVEN_HOME}/bin/mvn test"
                }
            }
        }

        // Build Docker Image Stage
        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                script {
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh 'docker build -t elvis054/demo:latest .'
                    }
                }
            }
        }

        // Push Docker Image Stage
        stage('Push Docker Image') {
            steps {
                echo 'Pushing Docker image to registry...'
                script {
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh 'echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin'
                        sh 'docker tag elvis054/demo:latest elvis054/demo:latest'
                        sh 'docker push elvis054/demo:latest'
                    }
                }
            }
        }

        // Deploy Docker Image Stage
        stage('Deploy Docker Image') {
            steps {
                echo 'Deploying Docker image...'
                script {
                    sh 'docker pull elvis054/demo:latest'
                    sh 'docker run -d -p 8081:8080 elvis054/demo:latest'
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
