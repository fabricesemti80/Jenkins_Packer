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
                    [void](New-Item -ItemType Directory -Name "answerFiles" -path ".\\$build" -ErrorAction Ignore)
                }
                """
                // copy script folders
                powershell """
                \$builds = @(${BUILDS})
                foreach (\$build in \$builds){
                    .\\Copy-Sources.ps1 -buildFolder \$build
                }
                """
                // prepare JSON & XML files
                powershell """
                \$builds = @(${BUILDS})
                \$clusters = @(${CLUSTERS})
                foreach (\$build in \$builds){
                    foreach (\$cluster in \$clusters)
                    {
                        .\\Create-JSON.ps1 -buildFolder \$build -buildName \$build -cluster \$cluster
                        .\\Create-XML.ps1 -buildFolder \$build -buildName \$build -cluster \$cluster
                    }
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
        // stage('Wipe workspace') {
        //     // wipe workspace
        //     steps {
        //         echo 'Removing build files...'
        //         powershell script: 'Start-Sleep -Seconds 30'
        //         powershell script: 'Get-childitem -Recurse | Remove-Item -Recurse -Force'
        //     }
        // }
    }
}
