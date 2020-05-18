#!/bin/sh -l

cd backend

cp .env.example .env

composer install --ignore-platform-reqs

php artisan key:generate

php artisan test