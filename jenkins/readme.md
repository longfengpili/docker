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
    + ${FILE,path="PATH"} 包括指定文件（路径）的含量相对于工作空间根目录。path文件路径，注意：是工作区目录的相对路径。
    + ${BUILD_NUMBER} 显示当前构建的编号。
    + ${JOB_DESCRIPTION} 显示项目描述。
    + ${SVN_REVISION} 显示svn版本号。还支持Subversion插件出口的SVN_REVISION_n版本。
    + ${CAUSE} 显示谁、通过什么渠道触发这次构建。
    + ${CHANGES} -显示上一次构建之后的变化。
        + showPaths 如果为 true,显示提交修改后的地址。默认false。
        + showDependencies 如果为true，显示项目构建依赖。默认为false
        + format 遍历提交信息，一个包含%X的字符串，其中%a表示作者，%d表示日期，%m表示消息，%p表示路径，%r表示版本。注意，并不是所有的版本系统都支持%d和%r。如果指定showPaths将被忽略。默认“[%a] %m\\n”。
        + pathFormat 一个包含“%p”的字符串，用来标示怎么打印路径。
    + ${BUILD_ID}显示当前构建生成的ID。
    + ${PROJECT_NAME} 显示项目的全名。
    + ${PROJECT_DISPLAY_NAME} 显示项目的显示名称。
    + ${SCRIPT} 从一个脚本生成自定义消息内容。自定义脚本应该放在"$JENKINS_HOME/email-templates"。当使用自定义脚本时会默认搜索$JENKINS_HOME/email-templatesdirectory目录。其他的目录将不会被搜索。
        + script 当其使用的时候，仅仅只有最后一个值会被脚本使用（不能同时使用script和template）。
        + template常规的simpletemplateengine格式模板。
    + ${JENKINS_URL} 显示Jenkins服务器的url地址（你可以再系统配置页更改）。
    + ${BUILD_LOG_MULTILINE_REGEX}按正则表达式匹配并显示构建日志。
        + regex java.util.regex.Pattern 生成正则表达式匹配的构建日志。无默认值，可为空。
        + maxMatches 匹配的最大数量。如果为0，将匹配所有。默认为0。
        + showTruncatedLines 如果为true，包含[...truncated ### lines...]行。默认为true。
        + substText 如果非空，就把这部分文字（而不是整行）插入该邮件。默认为空。
        + escapeHtml 如果为true，格式化HTML。默认为false。
        + matchedSegmentHtmlStyle 如果非空，输出HTML。匹配的行数将变为<b style=”your-style-value”> html escaped matched line </b>格式。默认为空。
    + ${BUILD_LOG} 显示最终构建日志。
        + maxLines 日志最多显示的行数，默认250行。
        + escapeHtml 如果为true，格式化HTML。默认false。
    + ${PROJECT_URL} 显示项目的URL地址。
    + ${BUILD_STATUS} -显示当前构建的状态(失败、成功等等)
    + ${BUILD_URL} -显示当前构建的URL地址。
    + ${CHANGES_SINCE_LAST_SUCCESS} -显示上一次成功构建之后的变化。
        + reverse在顶部标示新近的构建。默认false。
        + format遍历构建信息，一个包含%X的字符串，其中%c为所有的改变，%n为构建编号。默认”Changes for Build #%n\n%c\n”。
        + showPaths,changesFormat,pathFormat分别定义如${CHANGES}的showPaths、format和pathFormat参数。
    + ${CHANGES_SINCE_LAST_UNSTABLE} -显示显示上一次不稳固或者成功的构建之后的变化。
        + reverse在顶部标示新近的构建。默认false。
        + format遍历构建信息，一个包含%X的字符串，其中%c为所有的改变，%n为构建编号。默认”Changes for Build #%n\n%c\n”。
        + showPaths,changesFormat,pathFormat分别定义如${CHANGES}的showPaths、format和pathFormat参数。
    + ${ENV} –显示一个环境变量。
        var– 显示该环境变量的名称。如果为空，显示所有，默认为空。
    + ${FAILED_TESTS} -如果有失败的测试，显示这些失败的单元测试信息。
    + ${JENKINS_URL} -显示Jenkins服务器的地址。(你能在“系统配置”页改变它)。
    + ${HUDSON_URL} -不推荐，请使用$JENKINS_URL
    + ${PROJECT_URL} -显示项目的URL。
    + ${SVN_REVISION} -显示SVN的版本号。
    + ${JELLY_SCRIPT} -从一个Jelly脚本模板中自定义消息内容。有两种模板可供配置：HTML和TEXT。你可以在$JENKINS_HOME/email-templates下自定义替换它。当使用自动义模板时，”template”参数的名称不包含“.jelly”。
        + template模板名称，默认”html”。
    + ${TEST_COUNTS} -显示测试的数量。
        + var– 默认“total”。
            + total -所有测试的数量。
            + fail -失败测试的数量。
            + skip -跳过测试的数量。

+ Jenkinsfile 设定
```
post {
    always {
            emailext(recipientProviders: [requestor()],
                    subject: '${PROJECT_NAME} - Build # ${BUILD_NUMBER} - ${BUILD_STATUS}!', 
                    body: '${FILE,path="./email.html"}'，
                    attachLog: true)
    }
}
```
+ recipientProviders
    * culprits() 引发构建失败的人
    * developers()  此次构建所涉及的所有提交者
    * requestor() 请求构建的人
+ attachmentsPattern 提交附件
+ attachLog 日志
+ compressLog 是否压缩日志

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
