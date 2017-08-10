# based from:
# * https://github.com/carlossg/docker-maven/tree/master/jdk-7
# * https://hub.docker.com/r/anapsix/alpine-java/

FROM anapsix/alpine-java:7

ARG MAVEN_VERSION=3.1.1
ARG USER_HOME_DIR="/root"
ARG SHA=077ed466455991d5abb4748a1d022e2d2a54dc4d557c723ecbacdc857c61d51b
ARG BASE_URL=https://apache.rediris.es/maven/maven-3/${MAVEN_VERSION}/binaries

# update tar; see https://github.com/creationix/nvm/issues/1064
# update curl: see https://github.com/docker-library/official-images/issues/2773
RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && apk --update add tar \
  && apk --update add curl \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha256sum -c - \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

COPY mvn-entrypoint.sh /usr/local/bin/mvn-entrypoint.sh
COPY settings-docker.xml /usr/share/maven/ref/

VOLUME "$USER_HOME_DIR/.m2"

ENTRYPOINT ["/usr/local/bin/mvn-entrypoint.sh"]
CMD ["mvn"]