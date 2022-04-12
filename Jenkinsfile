#!groovy
import groovy.json.JsonSlurperClassic
//comment
node {
	def BUILD_NUMBER=env.BUILD_NUMBER
	def RUN_ARTIFACT_DIR="testss/${BUILD_NUMBER}"
	def SFDC_USERNAME

	def SFDC_HOST = env.SFDC_HOST_DH
	def SFDC_CLASSES = env.sf-classes
	def toolbelt = env.toolbelt

	println (SFDC_CLASSES)
	stage('checkout source') {
	// when running in multi-branch job, one must issue this command
		checkout scm
	}

	withCredentials([file(credentialsId:'SFDX-SANDBOX-KEY', variable:'jwt_key_file'),
	string(credentialsId: 'sf-sfdx-app-consumer-key-sandbox', variable: 'CONNECTED_APP_CONSUMER_KEY'),
	string(credentialsId: 'sf-sfdx-user-sandbox', variable: 'HUB_ORG')]) {
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
			println 'SFDX AUTHTICATED !'
			}
		}
		stage('Tests'){
			if (isUnix()) {
				userAdd = sh returnStdout: true, script:"${toolbelt} config:set defaultusername=${HUB_ORG} "
				//testsResult = sh returnStdout: true, script:"${toolbelt} force:apex:test:run --classnames ${SFDC_CLASSES} -c -r human"

			}else{
				userAdd = bat returnStdout: true, script:"${toolbelt} config:set defaultusername=${HUB_ORG} "
				testsResult = bat returnStdout: true, script:"${toolbelt} force:apex:test:run --classnames ${SFDC_CLASSES} -c -r human"
			}
			println(testsResult)
		}
		stage('Deploy') {

		if (isUnix()) {
			deployResult = sh returnStdout: true, script: "${toolbelt} force:source:deploy -x manifest/package.xml -u ${HUB_ORG}"
		}else{
			deployResult = bat returnStdout: true, script: "${toolbelt} force:source:deploy -x manifest/package.xml -u ${HUB_ORG}"
		}
		    
		    println(deployResult)

		}
	}
}
