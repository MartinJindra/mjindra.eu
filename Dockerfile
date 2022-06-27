FROM alpine:3.16
RUN apk add --no-cache hugo
ENV WORK_DIR /www
WORKDIR $WORK_DIR
ADD archetypes $WORK_DIR/archetypes
ADD content $WORK_DIR/content
ADD layouts $WORK_DIR/layouts
ADD static $WORK_DIR/static
ADD themes $WORK_DIR/themes
ADD config.yaml $WORK_DIR/config.yaml
ENTRYPOINT [ "hugo" ]

