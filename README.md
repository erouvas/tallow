## EAP Server with oracle driver and multiple war deployments

The following folders are used by the s2i builder process. We instruct the EAP build to add oracle driver and deploy multiple war files by configuring the contents.

*  *.s2i* - add environment var to instruct process to use deployments and extensions folders

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
  --build-env GIT_SSL_NO_VERIFY=true \
  --env-file extensions/datasources.env \
  -p ENABLE_GENERATE_DEFAULT_DATASOURCE=false \
  -p AUTO_DEPLOY_EXPLODED=true 
```

More info: https://github.com/jboss-openshift/application-templates/blob/master/docs/eap/eap71-basic-s2i.adoc 
 
To delete all resources for this application, use:

```
oc delete all,configmap,pvc,serviceaccount,rolebinding --selector app=lis7app
```

## KIE Server overview

```
curl --request GET \
  --url https://tallow-lis7.apps-crc.testing/kie-server/services/rest/server \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic YWRtaW5pc3R0aW9uMQ==' \
  --header 'Content-Type: application/json' \
```

Sample output for KIE Server overview:

```
{
	"type": "SUCCESS",
	"msg": "Kie Server info",
	"result": {
		"kie-server-info": {
			"id": "ks1",
			"version": "7.67.0.Final-redhat-00008",
			"name": "ks1",
			"location": "http://localhost:8230/kie-server/services/rest/server",
			"capabilities": [
				"KieServer",
				"BRM",
				"BPM",
				"CaseMgmt",
				"BPM-UI",
				"BRP",
				"DMN",
				"Swagger",
				"Prometheus"
			],
			"messages": [
				{
					"severity": "INFO",
					"timestamp": {
						"java.util.Date": 1663160957354
					},
					"content": [
						"Server KieServerInfo{serverId='ks1', version='7.67.0.Final-redhat-00008', name='ks1', location='http://localhost:8230/kie-server/services/rest/server', capabilities=[KieServer, BRM, BPM, CaseMgmt, BPM-UI, BRP, DMN, Swagger, Prometheus]', messages=null', mode=DEVELOPMENT}started successfully at Wed Sep 14 13:09:17 UTC 2022"
					]
				}
			],
			"mode": "DEVELOPMENT"
		}
	}
}
```



## Deploy KJAR to KIE Server

```
curl --request PUT \
  --url https://tallow-lis7.apps-crc.testing/kie-server/services/rest/server/containers/tr \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic YWRtaW5pc3RyYXMQ==' \
  --header 'Content-Type: application/json' \
  --data '{
    "container-id" : "tr",
    "release-id" : {
        "group-id" : "taxrules",
        "artifact-id" : "TaxRules",
        "version" : "1.1.8"
    }
}'
```

## Get deployed containers

```
curl --request GET \
  --url https://tallow-lis7.apps-crc.testing/kie-server/services/rest/server/containers \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic YWRtaW5pc3RyYXRvcjpJbnNwZWN0aW9uMQ==' \
  --header 'Content-Type: application/json' \
```

Sample output for deployed containers:

```
{
	"type": "SUCCESS",
	"msg": "List of created containers",
	"result": {
		"kie-containers": {
			"kie-container": [
				{
					"container-id": "tr",
					"release-id": {
						"group-id": "taxrules",
						"artifact-id": "TaxRules",
						"version": "1.1.8"
					},
					"resolved-release-id": {
						"group-id": "taxrules",
						"artifact-id": "TaxRules",
						"version": "1.1.8"
					},
					"status": "STARTED",
					"scanner": {
						"status": "DISPOSED",
						"poll-interval": null
					},
					"config-items": [
					],
					"messages": [
						{
							"severity": "INFO",
							"timestamp": {
								"java.util.Date": 1663161095894
							},
							"content": [
								"Container tr successfully created with module taxrules:TaxRules:1.1.8."
							]
						}
					],
					"container-alias": null
				}
			]
		}
	}
}
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
