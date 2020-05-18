#!/bin/sh -l

cd backend

cp .env.example .env

composer install --prefer-dist --ignore-platform-reqs

php artisan key:generate

php artisan test