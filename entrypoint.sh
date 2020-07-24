#!/bin/sh -l

cd backend

cp .env.example .env

composer install --prefer-dist

php artisan key:generate

php artisan test --exclude-group=local