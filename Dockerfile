FROM alpine:3
RUN apk add --no-cache hugo
ENV WORK_DIR /www
WORKDIR $WORK_DIR
ADD . $WORK_DIR/
ENTRYPOINT [ "hugo" ]

