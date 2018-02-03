// SCMの追加処理で Advanced sub-modules behavioursを選び
// サブモジュールを再帰的にアップデートにチェックをしてください

pipeline {
    agent any

    stages {
        stage('Clean') {
            steps {
                sh 'sudo rm -rf *'
            }
        }        

        stage('Checkout') {
            steps {
                checkout scm
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
            slackSend channel: '#times_tadashi-aikawa', color: 'danger', message: ':xymon_red:  ブログの更新に失敗', teamDomain: 'ntj', tokenCredentialId: 'NTJ_SLACK_TOKEN'
        }
    }
}

