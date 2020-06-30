From docker.elastic.co/elasticsearch/elasticsearch:7.5.2
ADD ./readonlyrest-1.20.0_es7.5.2.zip /plugins/readonlyrest-1.20.0_es7.5.2.zip
RUN echo -e "y" | /usr/share/elasticsearch/bin/elasticsearch-plugin install file:///plugins/readonlyrest-1.20.0_es7.5.2.zip
