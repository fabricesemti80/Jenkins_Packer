/* groovylint-disable CompileStatic */
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building..',
                echo 'We are here:',
                pwd
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
