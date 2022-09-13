## EAP Server with oracle driver and multiple war deployments

The following folders are used by the s2i builder process. We instruct the EAP build to add oracle driver and deploy multiple war files by configuring the contents.

*  *.s2i* - add environment var to instruct process to use deployments and extentions folders

*  *configuration*

*  *deployments* - it is possible to add .war files here and they will be deployed, all being well, to the EAP instance

*  *extensions* - contains s2i script to be used when configuring oracle driver, plus module.xml - see https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/7.4/html/getting_started_with_jboss_eap_for_openshift_container_platform/configuring_eap_openshift_image#S2I-Artifacts


```
oc new-app --template=eap74-basic-s2i -n lis7 --name=lis7app \
  -p APPLICATION_NAME=tallow \
  -p EAP_IMAGE_NAME=jboss-eap74-openjdk8-openshift:7.4.0  \
  -p EAP_RUNTIME_IMAGE_NAME=jboss-eap74-openjdk8-runtime-openshift:7.4.0 \
  -p SOURCE_REPOSITORY_URL=https://github.com/erouvas/tallow.git \
  -p SOURCE_REPOSITORY_REF=main \
  -p CONTEXT_DIR=. \
  --env-file extensions/datasources.env \
  -p ENABLE_GENERATE_DEFAULT_DATASOURCE=false ```
 
 
 
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
 
 
