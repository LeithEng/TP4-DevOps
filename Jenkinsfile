pipeline {
    agent any
    tools {
        nodejs 'NodeJS-18'
        sonarScanner 'SonarQubeScanner'
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