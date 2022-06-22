FROM registry.gitlab.com/tingo-public/laravel-tests/php-8.1:latest

WORKDIR /var/www/html

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]