# [参考链接](https://jenkins.io/zh/doc/tutorials/build-a-python-app-with-pyinstaller/)

# docker run
```docker
docker run -u root -e TZ="Asia/Shanghai" --name myjenkins -p 8080:8080 -v e:/jenkins/jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock -v E:/GoogleDrive/work_daily/daily_work:/home  jenkinsci/blueocean
```

# environment
1. 设置令牌环境变量
```
pipeline {
    agent any
    environment { 
        CC = 'clang'
    }
    stages {
        stage('Example') {
            environment { 
                AN_ACCESS_KEY = credentials('my-prefined-secret-text') 
            }
            steps {
                sh 'printenv'
            }
        }
    }
}
```
2. 设置动态环境变脸
```
pipeline {
    agent any 
    environment {
        // 使用 returnStdout
        CC = """${sh(
                returnStdout: true,
                script: 'echo $(date \'+%Y-%m-%d\')'
            )}""".trim()
        // 使用 returnStatus
        EXIT_STATUS = """${sh(
                returnStatus: true,
                script: 'exit 1'
            )}"""
    }
    stages {
        stage('Example') {
            environment {
                DEBUG_FLAGS = '-g'
            }
            steps {
                sh 'printenv'
            }
        }
    }
}
```
3. 设置环境变量
```
pipeline {
    agent any

    environment {
        FOO = "bar"
        NAME = "Joe"
    }

    stages {
        stage("Env Variables") {
            environment {
                NAME = "Alan" // overrides pipeline level NAME env variable
                BUILD_NUMBER = "2" // overrides the default BUILD_NUMBER
            }

            steps {
                echo "FOO = ${env.FOO}" // prints "FOO = bar"
                echo "NAME = ${env.NAME}" // prints "NAME = Alan"
                echo "BUILD_NUMBER =  ${env.BUILD_NUMBER}" // prints "BUILD_NUMBER = 2"

                script {
                    env.SOMETHING = "1" // creates env.SOMETHING variable
                }
            }
        }

        stage("Override Variables") {
            steps {
                script {
                    env.FOO = "IT DOES NOT WORK!" // it can't override env.FOO declared at the pipeline (or stage) level
                    env.SOMETHING = "2" // it can override env variable created imperatively
                }

                echo "FOO = ${env.FOO}" // prints "FOO = bar"
                echo "SOMETHING = ${env.SOMETHING}" // prints "SOMETHING = 2"

                withEnv(["FOO=foobar"]) { // it can override any env variable
                    echo "FOO = ${env.FOO}" // prints "FOO = foobar"
                }

                withEnv(["BUILD_NUMBER=1"]) {
                    echo "BUILD_NUMBER = ${env.BUILD_NUMBER}" // prints "BUILD_NUMBER = 1"
                }
            }
        }
    }
}
```

# parameters
```
pipeline {
    agent any
    parameters {
        string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')
        text(name: 'BIOGRAPHY', defaultValue: '', description: 'Enter some information about the person')
        booleanParam(name: 'TOGGLE', defaultValue: true, description: 'Toggle this value')
        choice(name: 'CHOICE', choices: ['One', 'Two', 'Three'], description: 'Pick something')
        password(name: 'PASSWORD', defaultValue: 'SECRET', description: 'Enter a password')
        file(name: 'key1', description: 'Choose a file to upload')
    }
    stages {
        stage('Example') {
            steps {
                echo "Hello ${params.PERSON}"
                echo "Biography: ${params.BIOGRAPHY}"
                echo "Toggle: ${params.TOGGLE}"
                echo "Choice: ${params.CHOICE}"
                echo "Password: ${params.PASSWORD}"
            }
        }
    }
}
```

# ANT 路径表达式
## 通配符
|通配符|说明|
|:-:|:-:|
|?|匹配任何单字符|
|*|匹配0或者任意数量的字符|
|**|匹配0或者更多的目录|
## examples
|URL路径|说明|
|:-:|:-:|
|/app/*.x|匹配(Matches)所有在app路径下的.x文件|
|/app/p?ttern|匹配(Matches) /app/pattern 和 /app/pXttern,但是不包括/app/pttern|
|/**/example|匹配(Matches) /app/example, /app/foo/example, 和 /example|
|/app/**/dir/file.*|匹配(Matches) /app/dir/file.jsp, /app/foo/dir/file.html,/app/foo/bar/dir/file.pdf和 /app/dir/file.java|
|/**/*.jsp|匹配(Matches)任何的.jsp 文件|
> 最长匹配原则(has more characters),URL请求/app/dir/file.jsp，现在存在两个路径匹配模式/**/*.jsp和/app/dir/*.jsp，那么会根据模式/app/dir/*.jsp来匹配


# 插件
## Email Extension Template Plugin
+ 设置email  
[email.html](./email.html)
+ Jenkinsfile 设定
```
post {
    always {
            emailext(recipientProviders: [requestor()],
                    subject: '${PROJECT_NAME} - Build # ${BUILD_NUMBER} - ${BUILD_STATUS}!', 
                    body: '${FILE,path="./email.html"}')
    }
}
```
+ recipientProviders
    * culprits() 引发构建失败的人
    * developers()  此次构建所涉及的所有提交者
    * requestor() 请求构建的人
+ attachmentsPattern 提交附件

## Version Number
```
environment {
    version = VersionNumber(projectStartDate: '', versionNumberString: '${BUILD_DATE_FORMATTED, "yyyy-MM-dd"}.${BUILDS_TODAY}', versionPrefix: "${JOB_NAME}_", worstResultForIncrement: 'SUCCESS')
   }
}
```

## Build Timestamp
1. 系统管理→系统配置→Build Timestamp
2. jenkinsfile 调用
```
parameters {
    string(name: 'DATEMIN', 
        defaultValue: "${TODAY}", 
        description: 'modified timestamp')
}
```

## user build vars
|变量|说明|
|:-:|:-:|
|BUILD_USER|Full name (first name + last name)|
|BUILD_USER_EMAIL|Email address|
|BUILD_USER_FIRST_NAME|First name|
|BUILD_USER_ID|Jenkins user ID|
|BUILD_USER_LAST_NAME|Last name|
```
stage('build user info') {
    steps {
        wrap([$class: 'BuildUser']) {
            script {
                BUILD_USER_ID = "${BUILD_USER_ID}"
                BUILD_USER = "${BUILD_USER}"
            }
        }
        echo "${BUILD_USER}"
    }
}
```
