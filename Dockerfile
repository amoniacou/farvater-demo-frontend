FROM nginxinc/nginx-unprivileged:1.29-alpine
ARG VERSION=dev
ARG REVISION=unknown
ENV BACKEND_URL=http://backend:8080
COPY nginx/default.conf.template /etc/nginx/templates/default.conf.template
COPY public/ /usr/share/nginx/html/
USER root
RUN features=$(cat /usr/share/nginx/html/features/*.txt 2>/dev/null | sed 's/\\/\\\\/g; s/"/\\"/g' | awk 'NR>1{printf ", "}{printf "%s",$0}') \
    && printf '{"service":"frontend","version":"%s","revision":"%s","features":"%s"}\n' "${VERSION}" "${REVISION}" "${features}" \
    > /usr/share/nginx/html/version.json
USER 101
EXPOSE 8080
