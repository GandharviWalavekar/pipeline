pipeline {
    agent any

    environment {
        TOMCAT_URL = 'http://192.168.1.62:8081/'
        SONAR_URL = 'http://192.168.1.62:9000/'
    }

    tools {
        maven 'Maven'
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Verify Sonar') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh """
                        mvn clean verify sonar:sonar \
                        -Dsonar.projectKey=pipeline \
                        -Dsonar.projectName=pipeline \
                        -Dsonar.host.url=${SONAR_URL} \
                        -Dsonar.login=${env.SONAR_AUTH_TOKEN}
                    """
                }
            }
        }

        stage('Build') {
            steps {
                sh "mvn clean install -Dmaven.test.skip=true"
            }
        }

        stage('Archive Artifact') {
            steps {
                archiveArtifacts artifacts: 'target/*.war', allowEmptyArchive: true
            }
        }

        stage('Deployment') {
            steps {
                deploy adapters: [tomcat11(
                    url: "${TOMCAT_URL}", 
                    credentialsId: 'tomcat'
                )],
                war: 'target/*.war',
                contextPath: 'pipeline'
            }
        }
    }

    post {
        always {
            script {
                def timestamp = sh(script: "date +'%Y-%m-%d_%H-%M-%S'", returnStdout: true).trim()
                def reportName = "build_report_${env.JOB_NAME}_${env.BUILD_NUMBER}_${timestamp}.txt"

                sh """
                    echo '===== Build Report =====' > ${reportName}
                    echo 'Job Name: ${env.JOB_NAME}' >> ${reportName}
                    echo 'Build Number: ${env.BUILD_NUMBER}' >> ${reportName}
                    echo 'Build ID: ${env.BUILD_ID}' >> ${reportName}
                    echo 'Timestamp: ${timestamp}' >> ${reportName}
                    echo 'Build Status: ${currentBuild.currentResult}' >> ${reportName}
                    echo '========================' >> ${reportName}
                """

                sh "jenkins-cli console ${env.JOB_NAME} ${env.BUILD_NUMBER} >> ${reportName} || echo 'Failed to fetch logs' >> ${reportName}"

                archiveArtifacts artifacts: "${reportName}", allowEmptyArchive: true
                env.REPORT_FILE = reportName // Store the filename for email
            }
        }

        success {
            script {
                emailext(
                    to: 'vinzyzk@gmail.com',
                    from: 'Jenkins Build Server <pipelinesmtp@gmail.com>',
                    subject: "✅ Build Successful: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                    body: """
                        <p>The build was successful.</p>
                        <ul>
                            <li><b>Job Name:</b> ${env.JOB_NAME}</li>
                            <li><b>Build Number:</b> ${env.BUILD_NUMBER}</li>
                            <li><b>Build ID:</b> ${env.BUILD_ID}</li>
                            <li><b>Timestamp:</b> ${timestamp}</li>
                            <li><b>Build Status:</b> ✅ SUCCESS</li>
                        </ul>
                        <p>Find the attached build report and logs.</p>
                    """,
                    mimeType: 'text/html',
                    attachmentsPattern: "${env.REPORT_FILE}"
                )
            }
        }

        failure {
            script {
                emailext(
                    to: 'vinzyzk@gmail.com',
                    from: 'Jenkins Build Server <pipelinesmtp@gmail.com>',
                    subject: "❌ Build Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                    body: """
                        <p>The build has failed.</p>
                        <ul>
                            <li><b>Job Name:</b> ${env.JOB_NAME}</li>
                            <li><b>Build Number:</b> ${env.BUILD_NUMBER}</li>
                            <li><b>Build ID:</b> ${env.BUILD_ID}</li>
                            <li><b>Timestamp:</b> ${timestamp}</li>
                            <li><b>Build Status:</b> ❌ FAILURE</li>
                        </ul>
                        <p>Please check the attached build report and logs for more details.</p>
                    """,
                    mimeType: 'text/html',
                    attachmentsPattern: "${env.REPORT_FILE}"
                )
            }
        }
    }
}
