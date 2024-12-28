#! /bin/sh
echo "Creating tmp/pids..."
mkdir -p tmp/pids/

echo "Enabling cache by creating tmp/caching-dev.txt"
touch tmp/caching-dev.txt

DIR="/gem_playground/"
if [ -d "$DIR" ]; then
  # Take action if $DIR exists. #
  echo "Copying Gemfile to source code..."
  cp -rf /gem_playground/Gemfile* .
fi

echo "Running db creation"
bundle exec rake db:create

echo "Running db's migration..."
bundle exec rake db:migrate

#echo "Running db's seed..."
bundle exec rake db:seed

# Start Application
echo "Starting up puma(app server)..."
bundle exec puma -C config/puma.rb