pipeline {
    stages {
        stage('Checkout') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/master']],
                    extensions: [[
                            $class: 'SubmoduleOption',
                            recursiveSubmodules: true
                    ]],
                ])
            }
        }

        stage('Build & Deploy') {
            steps {
                sh 'make release'
            }
        }
    }

    post { 
        success { 
            slackSend channel: '#times_tadashi-aikawa', color: 'good', message: ':tio:  ブログの更新に成功', teamDomain: 'ntj', tokenCredentialId: 'NTJ_SLACK_TOKEN'
        }

        failure { 
            slackSend channel: '#times_tadashi-aikawa', color: 'danger', message: ':tio:  ブログの更新に失敗', teamDomain: 'ntj', tokenCredentialId: 'NTJ_SLACK_TOKEN'
        }
    }
}
