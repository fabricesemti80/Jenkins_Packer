/* groovylint-disable CompileStatic, LineLength */
pipeline {
    agent any
    environment {
        VCENTER_CRED_FILE = 'D:\\Jenkins\\Jenkins_Packer\\Creds\\administrator_vsphere_local_cred.xml'
    }
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
                    [void](New-Item -ItemType Directory -Name "answerFiles" -path \$build -ErrorAction Ignore)
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
        stage('Cleanup-templates') {
            // removing vm templates
            steps {
                echo 'Removing templates'
                powershell """
                    \$vCenterCred = Import-clixml -Path ${VCENTER_CRED_FILE}
                    .\\Remove-Templates.ps1 -vCenterCred \$vCenterCred -builds \$builds
                """
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
        // stage('Cleanup-Workspace') {
        //     // wipe workspace
        //     steps {
        //         echo 'Cleaning up previous runs build files...'
        //         powershell script: 'Get-childitem -Recurse | Remove-Item -Recurse -Force'
        //     }
        // }
    }
}
