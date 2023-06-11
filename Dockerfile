# ベースイメージの指定
FROM php:7.4-apache

# 必要なパッケージのインストール
RUN apt-get update \
    && apt-get install -y \
        libzip-dev \
        unzip \
        libonig-dev \
        libxml2-dev \
        libpng-dev \
        libjpeg-dev \
        libfreetype6-dev \
    && docker-php-ext-install \
        pdo_mysql \
        mbstring \
        zip \
        exif \
        pcntl \
        bcmath \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

# Composerのインストール
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Laravelアプリケーションのディレクトリを作成
WORKDIR /var/www/html

# アプリケーションの依存関係をインストール
# COPY composer.json composer.lock ./
# RUN composer install --no-scripts --no-autoloader

# アプリケーションのソースコードをコピー
COPY . .

# アプリケーションの設定
# RUN composer dump-autoload
# RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Apacheの設定
# COPY docker/apache2.conf /etc/apache2/sites-available/000-default.conf
# RUN a2enmod rewrite

# ポートのエクスポート
EXPOSE 8000

# コンテナ起動時に実行されるコマンド
# CMD ["apache2-foreground"]
