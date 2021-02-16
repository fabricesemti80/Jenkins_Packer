/* groovylint-disable CompileStatic */
pipeline {
    agent any

    stages {
        stage('Build') {
            // here we create the build environment, preparing the work files for each selectd build
            steps {
                echo 'Building..'
                // where are we
                powershell """
                \$location = Get-location
                Write-Output "My location is \$location"
                """
                // create build files
                powershell """
                \$builds = @(${BUILDS})
                foreach (\$build in \$builds){
                    Write-Output "Building --> \$build"
                    New-Item -ItemType Directory -Name \$build -ErrorAction Ignore
                    \$buildfile = \$build + '_file.json'
                    New-item -Itemtype File -Name \$buildfile -Path \$build
                }
                """
                // ensure file structure is correct
                //bat script: 'dir /s'
                powershell script: '(Get-childitem -recourse).FullName'
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
