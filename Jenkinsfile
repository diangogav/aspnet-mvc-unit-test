// Declarative //
pipeline {
    agent { 
        label 'docker-windows'
    }
    stages {
        
        stage('Build') {
            steps {                
                sh 'nuget restore'
                bat 'msbuild -p:VSToolsPath=c:/MSBuild.Microsoft.VisualStudio.Web.targets.14.0.0.3/tools/VSToolsPath AspNetMvcUnitTest.sln /t:Clean'
                bat 'msbuild -p:Platform="Any CPU" -p:VSToolsPath=c:/MSBuild.Microsoft.VisualStudio.Web.targets.14.0.0.3/tools/VSToolsPath AspNetMvcUnitTest.sln'
            }
        }

        stage('Unit Test') {
            steps {
                bat 'nunit3-console --version'
                bat 'nunit3-console UnitTest/bin/Debug/UnitTest.dll'
            }
        }

        stage('Build Docker Image') {

            agent { 
                label 'test-windows'
            }
            
            environment {
                    tag = VersionNumber(versionNumberString: '${BUILD_DATE_FORMATTED,"yyyyMMdd"}-develop-${BUILDS_TODAY}');
            }
            
            steps {
                echo 'Creating image...' 
                script { 
                    myImage = docker.build("gcr.io/infra-su-desarrollo/hola-mundo:$tag","-f deploy-mvc.Dockerfile .") 
                } 
                echo 'Image created'
            }
        }
        
        stage('Push Docker Image') {
            
            agent { 
                label 'test-windows'
            }
            steps { 
                echo 'Pushing to registry...' 
                script { 
                    docker.withRegistry('https://gcr.io', 'gcr:infra-su-desarrollo') { 
                        myImage.push('latest')
                    } 
                } 
                echo 'Image pushed' 
            } 
        }

        stage('Deploy To Canary') {
            agent { 
                label 'test-windows'
            }
            
            steps {
                echo 'Creating image...' 
                script {                     
                    docker.withRegistry('https://gcr.io', 'gcr:infra-su-desarrollo') { 
                        sh 'docker stack deploy --compose-file docker-compose.yml app --with-registry-auth'
                    }
                } 
                echo 'Image created and deploy'
            }
        }

        stage('Deploy?') {
            steps {
                timeout(time:5, unit:'DAYS') {
                    input message:'Approve deployment?', submitter: 'it-ops'
                }
            }
        }
    }
}