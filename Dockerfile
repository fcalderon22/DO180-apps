FROM ubi8/ubi:8.3
LABEL org.opencontainers.image.authors="fcalderon22"

WORKDIR ${NEXUS_HOME}

ENV NEXUS_VERSION="2.14.3-02"
ENV NEXUS_HOME="/opt/nexus"
ADD ./nexus-2.14.3-02-bundle.tar.gz ./nexus-start.sh ${NEXUS_HOME}/

RUN /bin/bash -c \
	'yum install -y --setopt=tsflags=nodocs java-1.8.0-openjdk-devel && \
	yum clean all -y && \
	groupadd -r nexus -f -g 1001 && \
	useradd -u 1001 -r -g nexus -m -d ${NEXUS_HOME} -s /sbin/nologin -c "Nexus User" nexus && \
	ln -s ${NEXUS_HOME}/nexus-${NEXUS_VERSION} ${NEXUS_HOME}/nexus2 && \
	chown -R nexus:nexus ${NEXUS_HOME}'

#	tar -x -v -C ${NEXUS_HOME}/ -f nexus-2.14.3-02-bundle.tar.gz && \


USER nexus

VOLUME ["opt/nexus/sonatype-work"]

ENTRYPOINT nexus-start.sh
