pipeline {
    agent any
    stages {
        stage('Get source code from GitHub') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/jipara/bootcamp-hw.git'
            }
        }
        stage('Unit Test') {
            environment {
                PORT = 8081
            }
            steps {
                sh 'npm install'
                sh 'npm test'
            }
        }
        stage('Quality Test using SonarQube') {
            steps {
                script {
                    def scannerHome = tool 'SonarQubeScanner3'
                    withSonarQubeEnv('jenkins') {
                     sh "${scannerHome}/bin/sonar-scanner"
                    }
                }
            }    
        }        
        stage('Code Quality Check via SonarQube') {
            steps {
                script {
                    def scannerHome = tool 'sonarqube';
                    withSonarQubeEnv("jenkins") {
                    sh "${tool("sonarqube")}/bin/sonar-scanner \
                    -Dsonar.projectKey=test-node-js \
                    -Dsonar.sources=. \
                    -Dsonar.css.node=. \
                    -Dsonar.host.url=http://34.123.91.124:9000 \
                    -Dsonar.login=your-generated-token-from-sonarqube-container"
                    }
               }
           }
       }
        stage('Build Docker Image') {
            steps {
                sh 'gcloud builds submit --tag gcr.io/genuine-vent-308402/events-external:v${BUILD_NUMBER} .'
            }
        }
        stage('Submit Image to Docker Hub') {
            steps {
                sh 'gcloud builds submit --tag gcr.io/genuine-vent-308402/events-external:v${BUILD_NUMBER} .'
            }
        }
        stage('Connect to Kebernetes cluster') {
            steps {
                sh 'gcloud container clusters get-credentials kubernetes-bootcamp-cluster --zone us-central1-b --project genuine-vent-'
            }
        }
        stage('If deployment does not exist, create deployment on Kubernetes cluster') {
            steps {
                sh (''' if kubectl get deployment | grep events-external
                        then
                            echo "already running"
                        else
                            kubectl create deployment events-internal --image=gcr.io/genuine-vent-308402/events-external:v${BUILD_NUMBER}
                        fi  
                ''')
            }
        }
        stage('Get Image from Docker') {
            steps {
                sh 'kubectl set image deployment/events-external external-image=gcr.io/genuine-vent-308402/events-external:v${BUILD_NUMBER} --record'
            }
        }
        stage('Push Image to Kubernetes Cluster') {
            steps {
                sh 'kubectl set image deployment/events-external external-image=gcr.io/genuine-vent-308402/events-external:v${BUILD_NUMBER} --record'
            }
        }
    }
}

