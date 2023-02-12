FROM nginx:stable

WORKDIR /etc/nginx/stream.d

RUN sed -i 's|security.debian.org/debian-security|mirrors.ustc.edu.cn/debian-security|g' /etc/apt/sources.list \
 && sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
 && apt update \
 && apt install -y golang

RUN echo "stream {" >> /etc/nginx/nginx.conf \
 && echo "    include /etc/nginx/stream.d/*.conf;" >> /etc/nginx/nginx.conf \
 && echo "}" >> /etc/nginx/nginx.conf

COPY nginx-dynamic-proxy ./nginx-dynamic-proxy-src

RUN ls

RUN cd nginx-dynamic-proxy-src \
 && go build -o "nginx-dynamic-proxy" \
 && mv nginx-dynamic-proxy .. \
 && cd .. \
 && rm -r nginx-dynamic-proxy-src

CMD nginx -g "daemon off;" > /dev/null 2>&1 & /etc/nginx/stream.d/nginx-dynamic-proxy
# CMD nginx
