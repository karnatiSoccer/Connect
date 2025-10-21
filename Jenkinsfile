pipeline {
    // 1. Specify which Jenkins agent (machine) to use
    agent any 

    // 2. Tell Jenkins to use the NodeJS tool we configured in Step 2
    tools {
        nodejs 'NodeJS-18' // Must match the name from Global Tool Configuration
    }

    // 3. Define the stages of your pipeline
    stages {
        stage('Checkout') {
            steps {
                // Get the code from your Git repository
                git 'https://github.com/karnatiSoccer/Connect.git'
            }
        }

        stage('Install Backend Dependencies') {
            steps {
                // Run npm install inside the 'backend' folder
                dir('backend') {
                    sh 'npm install'
                }
            }
        }
        
        stage('Install Frontend Dependencies') {
            steps {
                // Run npm install inside the 'frontend' folder
                dir('frontend') {
                    sh 'npm install'
                }
            }
        }

        stage('Run Tests') {
            steps {
                // (Optional) Run your backend tests
                dir('backend') {
                    sh 'npm test'
                }
            }
        }

        // This stage is no longer needed, as the Dockerfile handles the React build.
        // We'll leave the 'npm install' for the 'frontend' to cache it for the Docker build.
        // stage('Build React App') {
        //     steps {
        //         dir('frontend') {
        //             sh 'npm run build'
        //         }
        //     }
        // }

        stage('Build Docker Image') {
            steps {
                // Use the Docker Pipeline plugin to build the image
                // It will automatically find the 'Dockerfile' in the root
                // 'Connect' is the name of the image
                script {
                    docker.build("soccerkarnati/connect:${env.BUILD_NUMBER}")
                }
            }
        }
        
        stage('Push Docker Image') {
            // (Optional) This pushes your new image to Docker Hub
            // You must configure 'dockerhub-credentials' in Jenkins
            // Manage Jenkins > Credentials > System > Global credentials
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