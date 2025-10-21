pipeline {
    agent any

    tools {
        nodejs 'NodeJS-18'
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/karnatiSoccer/Connect.git'
            }
        }

        stage('Install Backend Dependencies') {
            steps {
                dir('backend') {
                    sh 'npm install'
                }
            }
        }

        stage('Install Frontend Dependencies') {
            steps {
                dir('frontend') {
                    sh 'npm install'
                }
            }
        }

        stage('Run Tests') {
            steps {
                dir('backend') {
                    sh 'npm test'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("soccerkarnati/connect:${env.BUILD_NUMBER}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        docker.image("soccerkarnati/connect:${env.BUILD_NUMBER}").push()
                    }
                }
            }
        }
    }
}
