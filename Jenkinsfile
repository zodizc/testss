
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

                        }else{

                        }
                    }
                }
            }
            stage('Run Tests in ScratchOrg') {
                steps {
                    script {
                        if (isUnix()) {

                        }else{

                        }
                    }
                }
            }
            stage('Auth to SandBox') {
                steps {
                    script {
                       if (isUnix()) {

                        }else{

                        }
                    }
                }
            }
            stage('Deploy to SandBox') {
                steps {
                    script {
                        if (isUnix()) {

                        }else{

                        }
                    }
                }
            }
        }
    }

