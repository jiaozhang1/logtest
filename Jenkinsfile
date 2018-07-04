node() {
    def buildImage = 'index.alauda.cn/alaudak8s/s2i-java:latest'
    def imageRepo = 'index.alauda.cn/alaudak8s/hello-world'

    def gitAddress = 'https://github.com/alauda-devops-quickstarts/hello-world-java.git'
    def contextDir = 'examples/test-app-maven/'
    def gitRef = 'master'

    def subCommand = ""
    if (contextDir){
        subCommand = "$subCommand --context-dir=$contextDir"
    }

    def envParams = [
      'APP_OPTIONS': '',
      'APP_SUFFIX': '',
      'BUILDER_ARGS': '',
    ]
    envParams.each{
        if (it.value){
            subCommand = "$subCommand -e $it.key=$it.value"
        }
    }

    def imageTag = "${scmVars.GIT_COMMIT}"
    def imageUrl = imageRepo
    if (imageTag){
        imageUrl = "$imageRepo:$imageTag"
    }
    def registryCredentials = "project-zhangjiao-alauda-secret"
    withCredentials([usernamePassword(credentialsId: registryCredentials, passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
        sh """
        docker login $imageRepo -u $USERNAME -p $PASSWORD
        """
    }

    sh """
    s2i build ./ ${subCommand} ${buildImage} ${deploymentName}
    docker tag ${deploymentName} ${imageUrl}
    docker push ${imageUrl}
    """

    alaudaDevops.withProject(namespace) {
        echo "Updating the deployment $deploymentName with image $imageUrl in project ${alaudaDevops.project()}"

        def p = alaudaDevops.selector('deploy', deploymentName).object()
        p.metadata.labels['BUILD_ID']=env.BUILD_ID
        p.spec.template.spec.containers[0]['image'] = imageUrl
        alaudaDevops.apply(p)

        echo "Completed the update."
    }
}



