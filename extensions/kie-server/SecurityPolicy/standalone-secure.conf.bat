rem ### -*- batch file -*- ######################################################
rem #                                                                          ##
rem #  JBoss EAP Bootstrap Script Configuration                                ##
rem #                                                                          ##
rem #############################################################################

rem # $Id: run.conf.bat 88820 2009-05-13 15:25:44Z dimitris@jboss.org $

rem #
rem # This batch file is executed by run.bat to initialize the environment
rem # variables that run.bat uses. It is recommended to use this file to
rem # configure these variables, rather than modifying run.bat itself.
rem #

rem Uncomment the following line to disable manipulation of JAVA_OPTS (JVM parameters)
rem set PRESERVE_JAVA_OPTS=true

if not "x%JAVA_OPTS%" == "x" (
  echo "JAVA_OPTS already set in environment; overriding default settings with values: %JAVA_OPTS%"
  goto JAVA_OPTS_SET
)

rem #
rem # Specify the JBoss Profiler configuration file to load.
rem #
rem # Default is to not load a JBoss Profiler configuration file.
rem #
rem set "PROFILER=%JBOSS_HOME%\bin\jboss-profiler.properties"

rem #
rem # Specify the location of the Java home directory (it is recommended that
rem # this always be set). If set, then "%JAVA_HOME%\bin\java" will be used as
rem # the Java VM executable; otherwise, "%JAVA%" will be used (see below).
rem #
rem set "JAVA_HOME=C:\opt\jdk1.6.0_23"

rem #
rem # Specify the exact Java VM executable to use - only used if JAVA_HOME is
rem # not set. Default is "java".
rem #
rem set "JAVA=C:\opt\jdk1.6.0_23\bin\java"

rem #
rem # Specify options to pass to the Java VM. Note, there are some additional
rem # options that are always passed by run.bat.
rem #

rem # JVM memory allocation pool parameters - modify as appropriate.
set "JAVA_OPTS=-Xms2G -Xmx2G -XX:MetaspaceSize=96M -XX:MaxMetaspaceSize=1024m"

rem # Prefer IPv4
set "JAVA_OPTS=%JAVA_OPTS% -Djava.net.preferIPv4Stack=true"

rem # Make Byteman classes visible in all module loaders
rem # This is necessary to inject Byteman rules into AS7 deployments
set "JAVA_OPTS=%JAVA_OPTS% -Djboss.modules.system.pkgs=org.jboss.byteman"

rem # Sample JPDA settings for remote socket debugging
rem set "JAVA_OPTS=%JAVA_OPTS% -agentlib:jdwp=transport=dt_socket,address=8787,server=y,suspend=n"

rem # Sample JPDA settings for shared memory debugging
rem set "JAVA_OPTS=%JAVA_OPTS% -agentlib:jdwp=transport=dt_shmem,address=jboss,server=y,suspend=n"

rem # Use JBoss Modules lockless mode
rem set "JAVA_OPTS=%JAVA_OPTS% -Djboss.modules.lockless=true"

:JAVA_OPTS_SET

rem # Uncomment this to run with a security manager enabled
rem set "SECMGR=true"

rem # Uncomment to add a Java agent. If an agent is added to the module options, then jboss-modules.jar is added as an agent
rem # on the JVM. This allows things like the log manager or security manager to be configured before the agent is invoked.
rem # MODULE_OPTS="-javaagent:agent.jar"

rem # Uncomment to run server in debug mode
rem set "DEBUG_MODE=true"
rem set "DEBUG_PORT=8787"

rem enable garbage collection logging if not set in environment differently
if "x%GC_LOG%" == "x" (
  set "GC_LOG=true"
) else (
  echo "GC_LOG set in environment to %GC_LOG%"
)
rem # Enforce security policy to avoid malicious java code running 
set "SECMGR=true"
set "DIRNAME_VAL=%DIRNAME%"
set "ESCAPED=file:///"

:nextval
for /F "tokens=1,* delims= " %%a in ("%DIRNAME_VAL%") do (
set "CHUNK=%%a"
set "DIRNAME_VAL=%%b"
)
set "ESCAPED=%ESCAPED%%CHUNK%"
if defined DIRNAME_VAL set "ESCAPED=%ESCAPED%%%20" & goto nextval

set "ESCAPED=%ESCAPED:\=/%"
set "JAVA_OPTS=%JAVA_OPTS% -Djboss.modules.policy-permissions=true -Djava.security.policy=%ESCAPED%security.policy -Dkie.security.policy=%ESCAPED%kie.policy"

