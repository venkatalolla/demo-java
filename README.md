# Demo Java Web Application

Simple java project demo that builds a war file and builds a deployable Docker image using `.gitlab-ci.yaml` file.

## Build

The build script uses `mvn package` to produce a demo.war file and then bundles it with a Docker image that runs Tomcat.
    
## Test

The Test script uses `mvn test` to test the applcation .war file before it bundles with a Docker image that runs Tomcat.


## Docker Build

* mvn package was ran and the `target/demo.war` was moved into `pkg/demo.war`
* a docker image was built which copied the `pkg/demo.war` to `/usr/local/tomcat/webapps/demo.war`. Check out the [Dockerfile](Dockerfile) for details.

Here's an example of some things to check after running the build script:

    $ ls pkg/demo.war
    pkg/demo.war
    $ docker images
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    demo-java           latest              88092dfb7325        6 minutes ago       591MB
    tomcat              8.5                 a92c139758db        2 weeks ago         558MB
    $

## Docker Run in local machine

Here are the summarized commands to run and test that Tomcat is serving the war file:

    docker run --rm -p 8080:8080 -d demo-java
    docker exec -ti $(docker ps -ql) bash
    curl localhost:8080/demo/Hello
    curl localhost:8080/demo/index.jsp
    exit
    docker stop $(docker ps -ql)
