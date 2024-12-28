FROM ruby:3.1.2

# Installing required libraries
RUN apt-get update -qq
RUN apt-get install -y build-essential curl git nodejs libmariadb-dev figlet vim

# Copy the Gemfile and Gemfile.lock.bck.bk
RUN mkdir /gem_playground
WORKDIR /gem_playground

COPY Gemfile* ./

# Install Gems dependencies
RUN gem install bundler && bundle install

RUN mkdir -p /app
WORKDIR /app
COPY . .

RUN groupadd --system ubuntu
RUN useradd -u 1001 --system ubuntu -g ubuntu -d /home/ubuntu -m -s /bin/bash
RUN chown -R ubuntu /app
RUN chmod -R 777 /app

# Adding figlet :)
RUN echo "figlet -cl 'Autonium'" >> /home/ubuntu/.bashrc

# Switching to non-root user 'ubuntu'
USER ubuntu

# Exposing 3000 port
EXPOSE 3000

ENTRYPOINT ["sh", "./config/docker/startup.sh"]