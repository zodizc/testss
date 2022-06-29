
pipeline {
    agent any
    environment {
        jwt_key_file = credentials('5ad9e141-21dc-42fe-afb2-b79dd63e6eb8')  
    }
    
    stages {
   
            stage('checkout source') {
                steps {
                    checkout scm
                }
            }
            stage('Create ScratchOrg') {
                steps {
                    script {
                        if (isUnix()) {
                            //update Salesforce CLI
                            update = sh(script: "${env.toolbelt} update stable-rc")
                            //Login to Prod using connected app consumer key, user name, prod url and OpenSSL certificate and key
                            login = sh(returnStatus: true, script: "${env.toolbelt} auth:jwt:grant --clientid 3MVG9WtWSKUDG.x4A4I1E1o5ll5tjOK71TFl3t.UvNsF2btB6WTVvUfplndUVu9uHmVaQV4WfapwP8UNjJkV8 --username mafarouq@leyton.com --jwtkeyfile ${jwt_key_file} --loglevel DEBUG --setdefaultdevhubusername --instanceurl https://login.salesforce.com --setalias HubOrg")
                            //Create scratchOrg from Prod
                            scratchOrg = sh(returnStatus: true, script: "${env.toolbelt} force:org:create --targetdevhubusername HubOrg --setdefaultusername --definitionfile config/project-scratch-def.json --setalias ciorg --wait 10 --durationdays 1")
                            if (scratchOrg != 0) {
                                error 'Salesforce scratch org creation failed.'
                            }	
                        }else{
                            //update Salesforce CLI
                            update = bat(script: "${env.toolbelt} update stable-rc")
                            //Login to Prod using connected app consumer key, user name, prod url and OpenSSL certificate and key
                            login = bat(returnStatus: true, script: "${env.toolbelt} auth:jwt:grant --clientid 3MVG9WtWSKUDG.x4A4I1E1o5ll5tjOK71TFl3t.UvNsF2btB6WTVvUfplndUVu9uHmVaQV4WfapwP8UNjJkV8 --username mafarouq@leyton.com --jwtkeyfile ${jwt_key_file} --loglevel DEBUG --setdefaultdevhubusername --instanceurl https://login.salesforce.com --setalias HubOrg")
                            //Create scratchOrg from Prod
                            scratchOrg = bat(returnStatus: true, script: "${env.toolbelt} force:org:create --targetdevhubusername HubOrg --setdefaultusername --definitionfile config/project-scratch-def.json --setalias ciorg --wait 10 --durationdays 1")
                            if (scratchOrg != 0) {
                                error 'Salesforce scratch org creation failed.'
                            }
                        }
                        if (login != 0) { 
                            error 'Hub Org authorization failed.' 
                        }
                        else{
                            println 'SFDX AUTHENTICATED !'
                        }                
                    }
                }
            }
            stage('Deploy to ScratchOrg') {
                steps {
                    script {
                        if (isUnix()) {
                            try{
                                //Push changes from Git Lab to scratch org
                                push = sh (returnStatus: true, script: "${env.toolbelt} force:source:push --targetusername ciorg")
                            }catch(err){
                                //Delete Scratch org
                                logout = sh (returnStatus: true, script: "${env.toolbelt} force:org:delete -p -u ciorg")
                                error 'Push to scratch org creation failed.'
                            }
                        }else{
                             try{
                                //Push changes from Git Lab to scratch org
                                push = bat (returnStatus: true, script: "${env.toolbelt} force:source:push --targetusername ciorg")
                            }catch(err){
                                //Delete Scratch org
                                logout = bat (returnStatus: true, script: "${env.toolbelt} force:org:delete -p -u ciorg")
                                error 'Push to scratch org creation failed.'
                            } 
                        }
                    }
                }
            }
            stage('Run Tests in ScratchOrg') {
                steps {
                    script {
                        if (isUnix()) {
                            try{
                                //Run tests in scratch org
                                testres = sh (returnStdout: true, script:"${env.toolbelt} force:apex:test:run --targetusername ciorg --wait 10 -l RunAllTestsInOrg -c -r human -d \"C:\\Users\\mafarouq\\Desktop\\testReport\"")
                            }catch(err){
                                //Delete Scratch org
                                logout = sh (returnStdout: true, script: "${env.toolbelt} force:org:delete -p -u ciorg")
                                error 'Scratch org tests failed.'
                            }
                        }else{
                             try{
                                //Run tests in scratch org
                                testres = bat (returnStdout: true, script:"${env.toolbelt} force:apex:test:run --targetusername ciorg --wait 10 -l RunAllTestsInOrg -c -r human -d \"C:\\Users\\mafarouq\\Desktop\\testReport\"")
                            }catch(err){
                                //Delete Scratch org
                                logout = bat (returnStdout: true, script: "${env.toolbelt} force:org:delete -p -u ciorg")
                                error 'Scratch org tests failed.'
                            }
                        }
                    }
                }
            }
            stage('Auth to SandBox') {
                steps {
                    script {
                        if (isUnix()) {
                            //Delete Scratch org
                            logout = sh (returnStatus: true, script: "${toolbelt} force:org:delete -p -u ciorg")
                            //Log out from Prod
                            logout = sh (returnStatus: true, script: "echo y | ${toolbelt} auth:logout --targetusername HubOrg")
                            //Log in to SandBox
                            slogin = sh (returnStatus: true, script: "${toolbelt} auth:jwt:grant --clientid ${env.CONNECTED_APP_CONSUMER_KEY_DH} --username mafarouq@leyton.com.isoprod2 --jwtkeyfile ${jwt_key_file} --setdefaultdevhubusername --instanceurl https://test.salesforce.com --setalias SandBox")
                        }else{
                            //Delete Scratch org
                            logout = bat (returnStatus: true, script: "${toolbelt} force:org:delete -p -u ciorg")
                            //Log out from Prod
                            logout = bat (returnStatus: true, script: "echo y | ${toolbelt} auth:logout --targetusername HubOrg")
                            //Log in to SandBox
                            slogin = bat (returnStatus: true, script: "${toolbelt} auth:jwt:grant --clientid ${env.CONNECTED_APP_CONSUMER_KEY_DH} --username mafarouq@leyton.com.isoprod2 --jwtkeyfile ${jwt_key_file} --setdefaultdevhubusername --instanceurl https://test.salesforce.com --setalias SandBox")
                        }
                    }
                }
            }
            stage('Deploy to SandBox') {
                steps {
                    script {
                        if (isUnix()) {
                            try{
                                //Deploy and check code coverage in SandBox
                                deployResult = sh (returnStdout: true, script: "${toolbelt} force:source:deploy -x manifest/package.xml -u mafarouq@leyton.com.isoprod2 -l RunSpecifiedTests -r \"TemperatureConverterTest,HelloAllTest\"")
                                //Log out from SnadBox
                                logout = sh (returnStatus: true, script: "echo y | ${toolbelt} auth:logout --targetusername SandBox ")
                                println 'Deploy succeed.'
                            }catch(err){
                                //Show tests result if deploy fail
                                println testres
                                //Log out from SnadBox
                                logout = sh (returnStatus: true, script: "echo y | ${toolbelt} auth:logout --targetusername SandBox ")
                                error 'Deploy failed.'
                            }
                        }else{
                            try{
                                //Deploy and check code coverage in SandBox
                                deployResult = bat (returnStdout: true, script: "${toolbelt} force:source:deploy -x manifest/package.xml -u mafarouq@leyton.com.isoprod2 -l RunSpecifiedTests -r \"TemperatureConverterTest,HelloAllTest\"")
                                //Log out from SnadBox
                                logout = bat (returnStatus: true, script: "echo y | ${toolbelt} auth:logout --targetusername SandBox ")
                                println 'Deploy succeed.'
                            }catch(err){
                                //Show tests result if deploy fail
                                println testres
                                //Log out from SnadBox
                                logout = bat (returnStatus: true, script: "echo y | ${toolbelt} auth:logout --targetusername SandBox ")
                                error 'Deploy failed.'
                            }
                        }
                    }
                }
            }
        }
    }

