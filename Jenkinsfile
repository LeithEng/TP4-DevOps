pipeline {
    agent any
    tools {
        nodejs 'NodeJS-18'   // Configurer dans Jenkins Global Tools
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/votre-user/mon-app-devops.git'
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
                        sh '''
                            sonar-scanner \
                              -Dsonar.projectKey=mon-app-devops \
                              -Dsonar.sources=src \
                              -Dsonar.javascript.lcov.reportPaths=coverage/lcov.info
                        '''
                    }
                }
            }
        }
        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
    }
    post {
        failure { echo 'Pipeline échoué. Vérifier SonarQube Quality Gate.' }
        success { echo 'CI réussi !' }
    }
}