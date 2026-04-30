pipeline {
    agent any
    tools {
        nodejs 'NodeJS-18'
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: ('ex1'),
                    url: 'https://github.com/LeithEng/TP4-DevOps.git'
            }
        }
        stage('Install Dependencies') {
            steps {
                dir('app') {
                    sh 'npm install'
                }
            }
        }
        stage('Unit Tests') {
            steps {
                dir('app') {
                    sh 'npm test -- --coverage'
                }
            }
            post {
                always {
                    junit 'app/coverage/junit.xml'
                }
            }
        }
        stage('Static Analysis - SonarQube') {
            steps {
                dir('app') {
                    withSonarQubeEnv('SonarQube') {
                        script {
                            def scannerHome = tool 'SonarQubeScanner'
                            sh """
                                ${scannerHome}/bin/sonar-scanner \
                                  -Dsonar.projectKey=mon-app-devops \
                                  -Dsonar.sources=src \
                                  -Dsonar.javascript.lcov.reportPaths=coverage/lcov.info
                            """
                        }
                    }
                }
            }
        }
        stage('Quality Gate') {
            steps {
                timeout(time: 20, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        stage('Docker Build') {
    steps {
        script {
            dockerImage = docker.build("votre-dockerhub-user/mon-app-devops:${BUILD_NUMBER}")
        }
    }
}

stage('Image Scanning - Trivy') {
    steps {
        sh """
            trivy image \
              --exit-code 0 \
              --severity HIGH,CRITICAL \
              --format table \
              votre-dockerhub-user/mon-app-devops:${BUILD_NUMBER}
        """
        // exit-code 1 pour bloquer le pipeline sur vulnérabilité CRITICAL
    }
}

stage('Docker Push') {
    steps {
        script {
            docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-credentials') {
                dockerImage.push("${BUILD_NUMBER}")
                dockerImage.push("latest")
            }
        }
    }
}
    }
    post {
        failure { echo 'Pipeline échoué. Vérifier SonarQube Quality Gate.' }
        success { echo 'CI réussi !' }
    }
}