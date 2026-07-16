FROM nginx:alpine

# Copy the built Flutter Web files
COPY build/web /usr/share/nginx/html

# Copy our custom Nginx configuration
COPY deploy/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
