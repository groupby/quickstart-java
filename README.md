GroupBy Quickstart Webapp
=========

![build](https://build.groupbyinc.com/app/rest/builds/buildType:id:JavaQuickStart_CommonReleaseDevelop/statusIcon)

Now private implementation of api-java using Java/Spring/JSP with the semantic layer built in.


The Semantic layer branch will exist for a little while.

Column two in the reference app will use the semantic layer.

The semantic layer configuration is here:

src/main/resources/semantify.yaml

Example configurations can be found at: https://github.com/groupby/edge/tree/master/semantify

The instructions below get you started with the cabelas endpoint.

Getting started
---

1. git clone https://github.com/groupby/quickstart-java.git
1. cd quickstart-java
1. git checkout semantify
1. mvn tomcat7:run
