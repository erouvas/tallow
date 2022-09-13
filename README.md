## EAP Server with oracle driver and multiple war deployments

The following folders are used by the s2i builder process. We instruct the EAP build to add oracle driver and deploy multiple war files by configuring the contents.

*  *.s2i* - add environment var to instruct process to use deployments and extentions folders

*  *configuration*

*  *deployments* - it is possible to add .war files here and they will be deployed, all being well, to the EAP instance

*  *extensions* - contains s2i script to be used when configuring oracle driver, plus module.xml - see https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/7.4/html/getting_started_with_jboss_eap_for_openshift_container_platform/configuring_eap_openshift_image#S2I-Artifacts


*Log from OCP showing loaded driver and deployed .war (from deployments folder)*
<pre>
[0m[0m21:40:38,326 INFO  [org.wildfly.extension.undertow] (MSC service thread 1-1) WFLYUT0003: Undertow 2.2.12.Final-redhat-00001 starting
[0m[0m21:40:38,328 INFO  [org.jboss.as.connector.subsystems.datasources] (ServerService Thread Pool -- 42) WFLYJCA0004: Deploying JDBC-compliant driver class oracle.jdbc.OracleDriver (version 11.2)
[0m[0m21:40:38,544 INFO  [org.jboss.as.ejb3] (MSC service thread 1-1) WFLYEJB0482: Strict pool mdb-strict-max-pool is using a max instance size of 4 (per class), which is derived from the number of CPUs on this host.
[0m[0m21:40:38,544 INFO  [org.jboss.as.ejb3] (MSC service thread 1-1) WFLYEJB0481: Strict pool slsb-strict-max-pool is using a max instance size of 16 (per class), which is derived from thread worker pool sizing.
[0m[0m21:40:38,546 INFO  [org.jboss.as.connector.deployers.jdbc] (MSC service thread 1-1) WFLYJCA0018: Started Driver service with driver-name = oracle
[0m[0m21:40:38,549 INFO  [org.jboss.as.connector.deployers.jdbc] (MSC service thread 1-1) WFLYJCA0018: Started Driver service with driver-name = h2
[0m[0m21:40:38,562 INFO  [org.jboss.as.naming] (MSC service thread 1-2) WFLYNAM0003: Starting Naming Service
[0m[0m21:40:38,669 INFO  [org.jboss.as.mail.extension] (MSC service thread 1-2) WFLYMAIL0001: Bound mail session [java:jboss/mail/Default]
[0m[0m21:40:38,783 INFO  [org.wildfly.extension.undertow] (MSC service thread 1-2) WFLYUT0012: Started server default-server.
[0m[0m21:40:38,786 INFO  [org.jboss.as.patching] (MSC service thread 1-2) WFLYPAT0050: JBoss EAP cumulative patch ID is: base, one-off patches include: none
[0m[0m21:40:38,789 INFO  [org.wildfly.extension.undertow] (MSC service thread 1-2) WFLYUT0006: Undertow HTTP listener default listening on 0.0.0.0:8080
[0m[0m21:40:38,791 INFO  [org.wildfly.extension.undertow] (MSC service thread 1-2) Queuing requests.
[0m[0m21:40:38,792 INFO  [org.wildfly.extension.undertow] (MSC service thread 1-2) WFLYUT0018: Host default-host starting
[0m[0m21:40:38,815 INFO  [org.jboss.as.server.deployment] (MSC service thread 1-2) WFLYSRV0027: Starting deployment of "ROOT.war" (runtime-name: "ROOT.war")
[0m[0m21:40:38,815 INFO  [org.jboss.as.server.deployment] (MSC service thread 1-1) WFLYSRV0027: Starting deployment of "helloworld.war" (runtime-name: "helloworld.war")
[0m[0m21:40:38,822 INFO  [org.jboss.as.server.deployment.scanner] (MSC service thread 1-1) WFLYDS0013: Started FileSystemDeploymentService for directory /opt/eap/standa
</pre>


```
oc new-app --template=eap74-basic-s2i -n lis7 --name=lis7app\
  -p EAP_IMAGE_NAME=jboss-eap74-openjdk8-openshift:7.4.0  \
  -p EAP_RUNTIME_IMAGE_NAME=jboss-eap74-openjdk8-runtime-openshift:7.4.0 \
  -p SOURCE_REPOSITORY_URL=https://github.com/erouvas/jboss-eap-quickstarts.git \
  -p SOURCE_REPOSITORY_REF=7.4.x \
  -p CONTEXT_DIR=helloworld-html5 \
  --env-file extensions/datasources.env \
  -p ENABLE_GENERATE_DEFAULT_DATASOURCE=false
 ```
 
 
 
 ----------------------------------------------
 
 **To override settings.xml for build**
 
 oc create configmap settings-mvn --from-file=../base_templates/settings.xml
 
 oc delete configmap settings-mvn
 
 Add to build config:
 
 <pre>
 source:
       configMaps:
      - configMap:
          name: settings-mvn
 </pre>
 
 
