#!/bin/sh -l

cd backend

composer install --prefer-dist

cp .env.example .env

php artisan key:generate

composer run test