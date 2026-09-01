FROM alpine:3.24
RUN apk add --no-cache openjdk25-jre-headless supervisor fish grep eudev-libs
ADD files /
CMD ["supervisord", "-c", "/supervisord.conf"]