FROM nginx:stable as nginx

FROM openresty/openresty:buster

COPY --from=nginx /docker-entrypoint.sh /
COPY --from=nginx /docker-entrypoint.d/ /docker-entrypoint.d/

COPY ./src/etc/nginx/templates/ /etc/nginx/templates/
COPY ./src/var/www/ /var/www/

CMD ["nginx", "-g", "daemon off;"]
ENTRYPOINT ["/docker-entrypoint.sh"]
