pipeline {
    agent any
    stages {
        withCredentials([file(credentialsId:'SFDX-SANDBOX-KEY', variable:'sandbox_jwt_key_file'),
        file(credentialsId:'SFDX-PRODUCTION-KEY', variable:'production_jwt_key_file'),
        string(credentialsId: 'sf-sfdx-app-consumer-key-sandbox', variable: 'SANDBOX_CONNECTED_APP_CONSUMER_KEY'),
        string(credentialsId: 'sf-sfdx-user-sandbox', variable: 'SANDBOX_USER'),
        string(credentialsId: 'sf-sfdx-app-consumer-key-production', variable: 'PROD_CONNECTED_APP_CONSUMER_KEY'),
        string(credentialsId: 'sf-sfdx-user-production', variable: 'PROD_USER')]) {
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
                            scratchOrg = sh(sh returnStatus: true, script: "${env.toolbelt} force:org:create --targetdevhubusername HubOrg --setdefaultusername --definitionfile config/project-scratch-def.json --setalias ciorg --wait 10 --durationdays 1")
                            if (scratchOrg != 0) {
                                error 'Salesforce scratch org creation failed.'
                            }	
                        }else{
                            //update Salesforce CLI
                            update = bat(script: "${env.toolbelt} update stable-rc")
                            //Login to Prod using connected app consumer key, user name, prod url and OpenSSL certificate and key
                            login = bat(returnStatus: true, script: "${env.toolbelt} auth:jwt:grant --clientid 3MVG9WtWSKUDG.x4A4I1E1o5ll5tjOK71TFl3t.UvNsF2btB6WTVvUfplndUVu9uHmVaQV4WfapwP8UNjJkV8 --username mafarouq@leyton.com --jwtkeyfile ${jwt_key_file} --loglevel DEBUG --setdefaultdevhubusername --instanceurl https://login.salesforce.com --setalias HubOrg")
                            //Create scratchOrg from Prod
                            scratchOrg = bat(sh returnStatus: true, script: "${env.toolbelt} force:org:create --targetdevhubusername HubOrg --setdefaultusername --definitionfile config/project-scratch-def.json --setalias ciorg --wait 10 --durationdays 1")
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
}
#!groovy
import groovy.json.JsonSlurperClassic
//comment
node {
	def BUILD_NUMBER=env.BUILD_NUMBER
	def RUN_ARTIFACT_DIR="testss/${BUILD_NUMBER}"
	def SFDC_USERNAME
	def HUB_ORG = env.HUB_ORG_DH
	def SFDC_HOST = env.SFDC_HOST_DH
	def JWT_KEY_CRED_ID = env.JWT_CRED_ID_DH
	def CONNECTED_APP_CONSUMER_KEY=env.CONNECTED_APP_CONSUMER_KEY_DH
	def testres
	def deployResult
	println 'KEY IS' 
	println BUILD_NUMBER
	println JWT_KEY_CRED_ID
	println HUB_ORG
	println SFDC_HOST
	println CONNECTED_APP_CONSUMER_KEY
	def toolbelt = env.toolbelt
	println 'KEY IS' 
	println BUILD_NUMBER
	println JWT_KEY_CRED_ID
	println HUB_ORG
	println SFDC_HOST
	println CONNECTED_APP_CONSUMER_KEY
	println toolbelt

	stage('checkout source') {
	// when running in multi-branch job, one must issue this command
		checkout scm
	}


	withCredentials([file(credentialsId:'5ad9e141-21dc-42fe-afb2-b79dd63e6eb8', variable:'jwt_key_file')]) {
		stage('Pull Docker image'){
			if (isUnix()) {
				login = sh returnStatus: true, script: "${toolbelt} update stable-rc"
				login = sh returnStatus: true, script: "${toolbelt} auth:jwt:grant --clientid 3MVG9WtWSKUDG.x4A4I1E1o5ll5tjOK71TFl3t.UvNsF2btB6WTVvUfplndUVu9uHmVaQV4WfapwP8UNjJkV8 --username mafarouq@leyton.com --jwtkeyfile ${jwt_key_file} --loglevel DEBUG --setdefaultdevhubusername --instanceurl https://login.salesforce.com --setalias HubOrg"
				scratchorg = sh returnStatus: true, script: "${toolbelt} force:org:create --targetdevhubusername HubOrg --setdefaultusername --definitionfile config/project-scratch-def.json --setalias ciorg --wait 10 --durationdays 1"
				if (scratchorg != 0) {
					error 'Salesforce test scratch org creation failed.'
				}
			
			}else{
				//login = bat returnStatus: true, script: "${toolbelt} update stable-rc"
				login = bat returnStatus: true, script: "${toolbelt} auth:jwt:grant --clientid 3MVG9WtWSKUDG.x4A4I1E1o5ll5tjOK71TFl3t.UvNsF2btB6WTVvUfplndUVu9uHmVaQV4WfapwP8UNjJkV8 --username mafarouq@leyton.com --jwtkeyfile ${jwt_key_file} --loglevel DEBUG --setdefaultdevhubusername --instanceurl https://login.salesforce.com --setalias HubOrg"
				scratchorg = bat returnStatus: true, script: "${toolbelt} force:org:create --targetdevhubusername HubOrg --setdefaultusername --definitionfile config/project-scratch-def.json --setalias ciorg --wait 10 --durationdays 1"
				if (scratchorg != 0) {
					error 'Salesforce test scratch org creation failed.'
				}
			}
		}


		/*stage('Deploy to ScratchOrg'){
			if (isUnix()) {
				push = sh returnStatus: true, script: "${toolbelt} force:source:push --targetusername ciorg"
				if (push != 0) {
					error 'Push to scratch org creation failed.'
				}
			}else{
				push = bat returnStatus: true, script: "${toolbelt} force:source:push --targetusername ciorg"
				if (push != 0) {
					error 'Push to scratch org creation failed.'
				}
			}
		}


		stage('Run Tests in ScratchOrg'){
			if (isUnix()) {
				testres = sh returnStdout: true, script: "${toolbelt} force:apex:test:run --targetusername ciorg --wait 10 --classnames \"TemperatureConverterTest,HelloAllTest\" -c -r human"			
			}else{
				try{
					//Run tests in scratch org
					testres = bat returnStdout: true, script: "${toolbelt} force:apex:test:run --targetusername ciorg --wait 10 --classnames \"TemperatureConverterTest,HelloAllTest\" -c -r human"
					println testres
					//deployResult = bat returnStdout: true, script: "${toolbelt} force:source:deploy -x manifest/package.xml -u mafarouq@leyton.com.isoprod2 -l RunSpecifiedTests -r TemperatureConverterTest,HelloAllTest7"
				}catch(err){
					//Delete Scratch org
					logout = bat returnStatus: true, script: "${toolbelt} force:org:delete -p -u ciorg"
					error 'Scratch org tests failed.'
				}
			}
		}*/


		stage('Stop old containers'){
			if (isUnix()) {
				//logout = sh returnStatus: true, script: "${toolbelt} force:org:delete -p -u ciorg"
				//logout = sh returnStatus: true, script: "echo y | ${toolbelt} auth:logout --targetusername HubOrg"
				login = sh returnStatus: true, script: "${toolbelt} auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username mafarouq@leyton.com.isoprod2 --jwtkeyfile ${jwt_key_file} --setdefaultdevhubusername --instanceurl ${SFDC_HOST} --setalias SandBox"
			}else{
				//logout = bat returnStatus: true, script: "${toolbelt} force:org:delete -p -u ciorg"
				//logout = bat returnStatus: true, script: "echo y | ${toolbelt} auth:logout --targetusername HubOrg"
				login = bat returnStatus: true, script: "${toolbelt} auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username mafarouq@leyton.com.isoprod2 --jwtkeyfile ${jwt_key_file} --loglevel DEBUG --setdefaultdevhubusername --instanceurl ${SFDC_HOST} --setalias SandBox"
			}

			if (login != 0) { 
				error 'hub org authorization failed' 
			}
			else{
				println 'SFDX AUTHENTICATED !'
			}
		}


		stage('Build docker containers') {
			if (isUnix()) {
				try{
					deployResult = sh returnStdout: true, script: "${toolbelt} force:source:deploy -x manifest/package.xml -u mafarouq@leyton.com.isoprod2 -l RunSpecifiedTests -r TemperatureConverterTest,HelloAllTest"
					logout = sh returnStatus: true, script: "echo y | ${toolbelt} auth:logout --targetusername SandBox "
					println 'Deploy succeed'
				}catch(err){
					println testres
					error 'Deploy fail check code coverage'
				}
			}else{
				try{
					deployResult = bat returnStdout: true, script: "${toolbelt} force:source:deploy -x manifest/package.xml -u mafarouq@leyton.com.isoprod2 -l RunSpecifiedTests -r TemperatureConverterTest,HelloAllTest"
					println  deployResult
					logout = bat returnStatus: true, script: "echo y | ${toolbelt} auth:logout --targetusername SandBox "
					println 'Deploy succeed'
				}catch(err){
					println  deployResult
					error 'Deploy fail check code coverage'
				}
			}
		}
	}
}
