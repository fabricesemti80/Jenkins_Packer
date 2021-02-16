/* groovylint-disable CompileStatic */
pipeline {
    agent any

    stages {
        stage('Build') {
            // here we create the build environment, preparing the work files for each selectd build
            steps {
                echo 'Building..'
                powershell """
                \$location = Get-location
                Write-Output "My location is \$location"
                """
            }
        }
        stage('Cleanup') {
            // removing vm templates
            steps {
                echo 'Cleaning up templates..'
            }
        }
        stage('Test') {
            // packer validate
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            // packer build
            steps {
                echo 'Deploying....'
            }
        }
    }
}
