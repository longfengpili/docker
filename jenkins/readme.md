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
    * ${FAILED_TESTS}  #如果任何测试失败，则显示失败的单元测试信息。
        * showStack   #在失败的测试输出中显示堆栈跟踪。默认为true。
        * showMessage  #在测试输出失败时显示错误消息。默认为true。
        * maxTests    #最多显示这么多测试。默认情况下不设置限制。
        * onlyRegressions  #仅显示与先前构建不同的失败测试。默认为false。
    * ${TEST_COUNTS,var="TYPE"}   #根据传入的类型（var）显示测试数（总计，通过，失败，跳过）。默认为总计。
    * ${GIT_BRANCH}   #扩展为已构建的分支的名称。
        * Parameters
            * all   #如果指定，则列出指向给定提交的所有分支。默认情况下，令牌会扩展为其中一个。
            * fullName  #如果指定，则此标记将扩展为完整的分支名称，例如“origin / master”。否则，它只会扩展为短名称，例如“master”。
    * ${GIT_REVISION}  #扩展为指向已构建的提交的Git SHA1提交ID。
        * Parameters
            * length=N (optional, default to 40)  #指定提交ID长度。完整的SHA1提交ID长度为40个字符，但通常会将其剪切为8或12，因为它通常提供足够的唯一性并且更加清晰。
    * ${ADMIN_EMAIL}   #显示Jenkins管理员的电子邮件地址
    * ${BUILD_CAUSE} + ${CAUSE}  #显示构建的原因。
    * ${BUILD_LOG_EXCERPT}   #显示构建日志的摘录。
        * start  #正则表达式匹配摘录起始行（排除匹配行）。
        * end   #正则表达式匹配摘录结束行（排除匹配行）。
    * ${BUILD_LOG}      #显示构建日志结尾。
        * maxLines   #最多显示这么多行的日志。默认为250。
        * escapeHtml  #如果为true，则HTML将被转义。默认为false。
    * ${BUILD_LOG_MULTILINE_REGEX}       #显示与正则表达式匹配的构建日志段。
        * regex   #java.util.regex.Pattern包含与此正则表达式匹配的构建日志的段。另请参见null。没有默认值。必需参数
        * maxMatches  #要包含的最大匹配数。如果为0，则将包括所有匹配。默认为0。
        * showTruncatedLines  #如果为true，则包括[...截断的### lines ...]行。默认为true。
        * substText   #如果为非null，请将此文本插入电子邮件而不是整个段。默认为null。
        * escapeHtml  #如果为true，则转义HTML。默认为false。
        * matchedSegmentHtmlStyle  #如果为非null，则输出HTML。匹配的行将变为<b style =“your-style-value”> html转义匹配行</ b>。默认为null。
    * ${BUILD_LOG_REGEX}        #显示构建日志中与正则表达式匹配的行。
        * regex   #包含与此正则表达式匹配的行。另请参见java.util.regex.Pattern.Defaults to“（？i）\\ b（error | exception | fatal | fail（ed | ure）| un（defined | resolved））\\ b”
        * linesBefore  #匹配行之前要包含的行数。与另一个匹配或linesAfter重叠的行仅包含一次。默认为0。
        * linesAfter  #匹配行后要包含的行数。与另一个匹配或linesBefore重叠的行只包含一次。默认为0。
        * maxMatches   #要包含的最大匹配数。如果为0，则将包括所有匹配。默认为0。
        * showTruncatedLines   #如果为true，则包括[...截断的### lines ...]行。默认为true。
        * substText   #如果为非null，请将此文本插入电子邮件而不是整行。默认为null。
        * escapeHtml   #如果为true，则转义HTML。违约是假的。
        * matchedLineHtmlStyle   #如果为非null，则输出HTML。匹配的行将变为<b style =“your-style-value”> html转义匹配行</ b>。默认为null。
        * addNewline    #如果为true，则在subsText之后添加换行符。默认为true。
        * defaultValue   #如果没有替换任何内容，将使用此值。
    * ${BUILD_NUMBER}        #扩展为当前内部版本号，这是一个标识构建的顺序自动递增唯一编号，例如“125”
    * ${BUILD_STATUS}   #显示当前构建的状态。（failing, success等......）
    * ${BUILD_URL}   #显示当前构建的URL
    * ${CHANGES_SINCE_LAST_BUILD} + ${CHANGES}   #显示自上次构建以来的更改。并非所有修订系统都支持％d和％r。如果指定showPaths参数被忽略。默认为“[％a]％m \\ n”
        * showDependencies   #如果为true，则显示此构建所依赖的项目的更改。默认为false
        * showPaths   #如果为true，则显示由提交修改的路径。默认为false
        * format    #对于列出的每个提交，包含％X的字符串，其中％x是以下之一：%a（作者）、%d(日期）、%m(信息)、%p(路径)、%r(版本)
        * pathFormat      #包含％p的字符串，指示如何打印路径。Defaults to "\\t%p\\n"
        * regex   #正则表达式。
        * replace  #替换与给定正则表达式匹配的更改消息的所有子字符串。
        * default  #未检测到更改时使用的消息。默认为“无更改\ n”
    * ${CHANGES_SINCE_LAST_SUCCESS}       #显示自上次成功构建以来的更改。默认为#%n\n%c\n
        * reverse  #如果为true，则将最新版本显示在顶部而不是底部。默认为false。
        * format   #对于列出的每个构建，包含％X的字符串，其中％X是其中之一
            * %c       #变化
            * %n       #编号
        * changesFormat     #对于构建中的每个更改。
    * ${CHANGES_SINCE_LAST_UNSTABLE}   #扩展到自上次不稳定或成功构建以来的更改。参数跟上面一样
    * ${ENV,var="VARIABLENAME"}   #从构建环境扩展到环境变量（此处指定为VARIABLENAME）。请注意，这不包括构建脚本本身设置的任何变量，只包括由Jenkins和其他插件设置的变量。
    * ${JENKINS_URL}   #显示Jenkins服务器的URL。 （您可以在系统配置页面上更改此设置。）
    * ${JOB_DESCRIPTION}  #显示作业的说明。
    * ${LOG_REGEX}   #使用正则表达式查找单个日志条目，并使用其中的捕获组生成新输出。这部分基于description-setter插件（https://github.com/jenkinsci/description-setter-plugin）。
    * ${PROJECT_NAME}  #显示项目的全名。 （参见AbstractProject.getFullDisplayName）
    * ${PROJECT_DISPLAY_NAME}  #显示项目的显示名称。 （参见AbstractProject.getDisplayName）
    * ${PROJECT_URL}   #显示项目页面的URL。
    * ${PROPFILE,file="FILENAME",property="PROPERTYNAME"}   #扩展为属性文件中的属性值。文件名相对于构建工作区根目录。
    * ${FILE,path="PATH"}   #扩展为文件的内容。文件路径相对于构建工作空间根目录。
    * ${XML,file="FILE",xpath="XPATH"}  #扩展到针对给定XML文件运行的XPath表达式的结果。如果XPath求值为多个值，则返回以分号分隔的字符串。文件路径相对于构建工作空间根目录。

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
