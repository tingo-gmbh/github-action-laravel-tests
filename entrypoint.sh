#!/bin/sh -l

if [ -d "backend" ]
then
echo "backend"
cd backend
elif [ -d "api" ]
then
echo "api"
cd api
fi

cp .env.example .env

composer install --prefer-dist

php artisan key:generate

php artisan test --exclude-group=local