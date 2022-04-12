#!groovy
import groovy.json.JsonSlurperClassic
//comment
node {
	def BUILD_NUMBER=env.BUILD_NUMBER
	def RUN_ARTIFACT_DIR="testss/${BUILD_NUMBER}"
	def SFDC_USERNAME

	def HUB_ORG=env.HUB_ORG_DH
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

	withCredentials([file(credentialsId:JWT_KEY_CRED_ID, variable:'jwt_key_file')]) {
		stage('Auth'){
			if (isUnix()) {
				rc = sh returnStatus: true, script: "${toolbelt} auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${HUB_ORG} --jwtkeyfile ${jwt_key_file} --setdefaultdevhubusername --instanceurl ${SFDC_HOST}"
			}else{
				rc = bat returnStatus: true, script: "${toolbelt} auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${HUB_ORG} --jwtkeyfile ${jwt_key_file} --loglevel DEBUG --setdefaultdevhubusername --instanceurl ${SFDC_HOST}"
			}

			if (rc != 0) { 
			println 'inside rc 0'
			error 'hub org authorization failed' 
			}
			else{
			println 'rc not 0'
			}
		}
		stage('tests'){
			if (isUnix()) {
				rm = sh returnStdout: true, script:"${toolbelt} config:set defaultusername=\"jenkinsapi@leyton.com.devadmin\""
				rms = sh returnStdout: true, script:"${toolbelt} force:apex:test:run --classnames \"TemperatureConverterTest\" -c -r human"

			}else{
				rm = bat returnStdout: true, script:"${toolbelt} config:set defaultusername=\"jenkinsapi@leyton.com.devadmin\""
				rms = bat returnStdout: true, script:"${toolbelt} force:apex:test:run --classnames \"TemperatureConverterTest\" -c -r human"
			}
			println(rms)
		}
		stage('Deploy') {

		if (isUnix()) {
			rmsg = sh returnStdout: true, script: "${toolbelt} force:source:deploy -x manifest/package.xml -u ${HUB_ORG}"
		}else{
			rmsg = bat returnStdout: true, script: "${toolbelt} force:source:deploy -x manifest/package.xml -u ${HUB_ORG}"
		}
		    
		    println(rmsg)

		}
	}
}
