FROM alpine:latest

COPY test.sh /
RUN chmod +x /test.sh

CMD /test.sh
