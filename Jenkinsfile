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
				rc = sh returnStatus: true, script: "${toolbelt} auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${HUB_ORG} --jwtkeyfile ${jwt_key_file} --setdefaultdevhubusername --instanceurl ${SFDC_HOST}"
			}else{
				rc = bat returnStatus: true, script: "${toolbelt} auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${HUB_ORG} --jwtkeyfile ${jwt_key_file} --loglevel DEBUG --setdefaultdevhubusername --instanceurl ${SFDC_HOST}"
			}

			if (rc != 0) { 
			error 'hub org authorization failed' 
			}
			else{
			println 'SFDX AUTHENTICATED !'
			}
		}
		
		stage('Tests'){
			if (isUnix()) {
				userAdd = sh returnStdout: true, script:"${toolbelt} config:set defaultusername=${HUB_ORG} "
				testsResult = sh returnStdout: true, script:"${toolbelt} force:apex:test:run --classnames ${SFDC_CLASSES} -c -r human"

			}else{
				userAdd = bat returnStdout: true, script:"${toolbelt} config:set defaultusername=${HUB_ORG} "
				//testsResult = bat returnStdout: true, script:"${toolbelt} force:apex:test:run --classnames \"TemperatureConverterTest,HelloAllTest\" -c -r human"
			}
			//println(testsResult)
		}
		stage('Deploy') {

		if (isUnix()) {
			deployResult = sh returnStdout: true, script: "${toolbelt} force:source:deploy -x manifest/package.xml -u ${HUB_ORG}"
		}else{
			deployResult = bat returnStdout: true, script: "${toolbelt} force:source:deploy -x manifest/package.xml -u ${HUB_ORG} -l RunSpecifiedTests -r TemperatureConverterTest -c"
		}
		    
		    println(deployResult)

		}
	}
}
