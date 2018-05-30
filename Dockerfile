FROM ruby:2.5.1

# リポジトリを更新し依存モジュールをインストール
RUN apt-get update -qq && \
    apt-get install -y build-essential \
                       postgresql-client \
                       nodejs

RUN gem install bundler

# ルート直下にlabosaという名前で作業ディレクトリを作成（コンテナ内のアプリケーションディレクトリ）
RUN mkdir /labosa
WORKDIR /labosa

# ホストのGemfileとGemfile.lockをコンテナにコピー
ADD Gemfile /labosa/Gemfile
ADD Gemfile.lock /labosa/Gemfile.lock

# bundle installの実行
RUN bundle install -j4 --without development test

# ホストのアプリケーションディレクトリ内をすべてコンテナにコピー
ADD . /labosa

# puma.sockを配置するディレクトリを作成
RUN mkdir -p tmp/sockets
