/* groovylint-disable CompileStatic, LineLength */
pipeline {
    agent any
    // environment {
    //     VCENTER_CRED_FILE = 'D:\\Jenkins\\Jenkins_Packer\\Creds\\administrator_vsphere_local_cred.xml'
    // }
    options {
        ansiColor('xterm')
    }
    stages {
        stage('Build') {
            // here we create the build environment, preparing the work files for each selectd build
            options {
                timeout(time: 1, unit: 'HOURS')
            }
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
                        .\\Create-XML.ps1 -buildFolder \$build -buildName \$build -cluster \$cluster -pKey2016 ${PKEY2016} -pKey2019 ${PKEY2019}
                    }
                }
                """
            // ensure file structure is correct
            // powershell script: '(Get-childitem -recurse | where-object {$_ -notlike "*git*"}).FullName'
            }
        }
        // stage('Cleanup-templates') {
        //     // removing vm templates
        //     options {
        //         timeout(time: 1, unit: 'HOURS')
        //     }
        //     steps {
        //         withCredentials([usernameColonPassword(credentialsId: 'b1d1ccf9-1ab1-4ff6-9f2c-3a2a09bbd91d', variable: 'VCENTER_CRED')]) {
        //             echo 'Removing templates'
        //             powershell """
        //             \$builds = @(${BUILDS})
        //             \$clusters = @(${CLUSTERS})
        //             .\\Remove-Templates.ps1 -vCenterAdmin ${VCENTER_ADMIN} -vCenterPwd ${VCENTER_PWD} -builds \$builds -clusters \$clusters
        //             """
        //         }
        //     }
        // }
        stage('Test') {
            // packer validate
            options {
                timeout(time: 1, unit: 'HOURS')
            }
            steps {
                echo 'Testing..'
                    powershell """
                    \$builds = @(${BUILDS})
                    \$clusters = @(${CLUSTERS})
                    .\\PACKER-Builder.ps1 -vCenterPwd ${VCENTER_PWD} -localPwd ${LOCAL_PWD} -builds \$builds -clusters \$clusters -mode seq
                    """
            }
        }
        stage('Deploy') {
            // packer build
            options {
                timeout(time: 4, unit: 'HOURS')
            }
            steps {
                echo 'Deploying...'
                    powershell """
                    \$builds = @(${BUILDS})
                    \$clusters = @(${CLUSTERS})
                    .\\PACKER-Builder.ps1 -vCenterPwd ${VCENTER_PWD} -localPwd ${LOCAL_PWD} -builds \$builds -clusters \$clusters -deploy -mode par
                    """
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
    post {
        always {
            powershell 'Get-Process *packer* | Stop-Process -Force'
        }
    }
}
