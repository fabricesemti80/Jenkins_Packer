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
                // create build folder
                powershell """
                \$builds = @(${BUILDS})
                foreach (\$build in \$builds){
                    Write-Output "Creating folder --> \$build"
                    [void](New-Item -ItemType Directory -Name \$build -ErrorAction Ignore)
                }
                """
                // copy script folders
                powershell """
                \$builds = @(${BUILDS})
                foreach (\$build in \$builds){
                    Write-Output "Copying source files --> \$build\\localScripts"
                    Copy-Item -Path "\\sources\\localScripts" -Destination "\$build\\localScripts" -Recurse
                    Write-Output "Copying source files --> \$build\\remoteScripts"
                    Copy-Item -Path "\\sources\\localScripts" -Destination "\$build\\remoteScripts" -Recurse
                }
                """
                // ensure file structure is correct
                powershell script: '(Get-childitem -recurse | where-object {$_ -notlike "*git*"}).FullName'
            }
        }
        stage('Cleanup templates') {
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
                echo 'Deploying...'
            }
        }
        stage('Wipe workspace') {
            // packer build
            steps {
                echo 'REmoving build files...'
                powershell script: 'Start-Sleep -Seconds 30'
                powershell script: 'Get-childitem -Recurse | Remove-Item -Recurse -Force'
            }
        }
    }
}
