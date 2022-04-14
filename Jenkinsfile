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

	println 'KEY IS' 
	println BUILD_NUMBER
	println JWT_KEY_CRED_ID
	println HUB_ORG
	println SFDC_HOST
	println CONNECTED_APP_CONSUMER_KEY
	def toolbelt = env.toolbelt
	println toolbelt

	stage('checkout source') {
	// when running in multi-branch job, one must issue this command
		checkout scm
	}


	withCredentials([file(credentialsId:'5ad9e141-21dc-42fe-afb2-b79dd63e6eb8', variable:'jwt_key_file')]) {
		stage('Auth'){
			if (isUnix()) {
				rc = sh returnStatus: true, script: "${toolbelt} auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${HUB_ORG} --jwtkeyfile ${jwt_key_file} --setdefaultdevhubusername --instanceurl ${SFDC_HOST} --setalias HubOrg"
			}else{
				rc = bat returnStatus: true, script: "${toolbelt} auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${HUB_ORG} --jwtkeyfile ${jwt_key_file} --loglevel DEBUG --setdefaultdevhubusername --instanceurl ${SFDC_HOST} --setalias SandBox"
			}

			if (rc != 0) { 
			error 'hub org authorization failed' 
			}
			else{
			println 'SFDX AUTHENTICATED !'
			}
		}
		stage('Deploy') {

		if (isUnix()) {
			try{
				deployResult = sh returnStdout: true, script: "${toolbelt} force:source:deploy -x manifest/package.xml -u ${HUB_ORG} -l RunSpecifiedTests -r TemperatureConverterTest,HelloAllTest"
			}catch(err){
			rc = sh returnStatus: true, script: "echo y | ${toolbelt} auth:logout --targetusername SandBox "
			rc = sh returnStatus: true, script: "${toolbelt} auth:jwt:grant --clientid 3MVG9WtWSKUDG.x4A4I1E1o5ll5tjOK71TFl3t.UvNsF2btB6WTVvUfplndUVu9uHmVaQV4WfapwP8UNjJkV8 --username mafarouq@leyton.com --jwtkeyfile ${jwt_key_file} --loglevel DEBUG --setdefaultdevhubusername --instanceurl https://login.salesforce.com --setalias HubOrg"
			rc = sh returnStatus: true, script: "${toolbelt} force:org:create --targetdevhubusername HubOrg --setdefaultusername --definitionfile config/project-scratch-def.json --setalias ciorg --wait 10 --durationdays 1"
			    if (rc != 0) {
				error 'Salesforce test scratch org creation failed.'
			    }
				rc = sh returnStatus: true, script: "${toolbelt} force:source:push --targetusername ciorg"
				rc = sh returnStatus: true, script: "${toolbelt} force:source:push --targetusername HubOrg"
				try{
					testres = sh "${toolbelt} force:apex:test:run --targetusername ciorg --wait 10 --classnames \"TemperatureConverterTest,HelloAllTest\" -c -r human"
				}catch(er){
					rc = sh returnStatus: true, script: "echo y | ${toolbelt} auth:logout --targetusername ciorg"    
					error 'Deploy Failed'
				}
			}
		}else{
			try{
				deployResult = bat returnStdout: true, script: "${toolbelt} force:source:deploy -x manifest/package.xml -u ${HUB_ORG} -l RunSpecifiedTests -r TemperatureConverterTest,HelloAllTest"
			}catch(err){
			rc = bat returnStatus: true, script: "echo y | ${toolbelt} auth:logout --targetusername SandBox "
			rc = bat returnStatus: true, script: "${toolbelt} auth:jwt:grant --clientid 3MVG9WtWSKUDG.x4A4I1E1o5ll5tjOK71TFl3t.UvNsF2btB6WTVvUfplndUVu9uHmVaQV4WfapwP8UNjJkV8 --username mafarouq@leyton.com --jwtkeyfile ${jwt_key_file} --loglevel DEBUG --setdefaultdevhubusername --instanceurl https://login.salesforce.com --setalias HubOrg"
			rc = bat returnStatus: true, script: "${toolbelt} force:org:create --targetdevhubusername HubOrg --setdefaultusername --definitionfile config/project-scratch-def.json --setalias ciorg --wait 10 --durationdays 1"
			    if (rc != 0) {
				error 'Salesforce test scratch org creation failed.'
			    }
				rc = bat returnStatus: true, script: "${toolbelt} force:source:push --targetusername ciorg"
				rc = bat returnStatus: true, script: "${toolbelt} force:source:push --targetusername HubOrg"
				try{
					testres = bat "${toolbelt} force:apex:test:run --targetusername ciorg --wait 10 --classnames \"TemperatureConverterTest,HelloAllTest\" -c -r human"
				}catch(er){
					rc = bat returnStatus: true, script: "echo y | ${toolbelt} auth:logout --targetusername ciorg"    
					error 'Deploy Failed'
				}
			}
		}
		  

		}
		/*stage('Tests'){
			if (isUnix()) {
				userAdd = sh returnStdout: true, script:"${toolbelt} config:set defaultusername=${HUB_ORG} "
				testsResult = sh returnStdout: true, script:"${toolbelt} force:apex:test:run --classnames ${SFDC_CLASSES} -c -r human"

			}else{
				userAdd = bat returnStdout: true, script:"${toolbelt} config:set defaultusername=${HUB_ORG} "
				testsResult = bat returnStdout: true, script:"${toolbelt} force:apex:test:run --classnames \"TemperatureConverterTest,HelloAllTest\" -c -r human"
			}
			println(testsResult)
		}*/
		
		
		
	}
}
