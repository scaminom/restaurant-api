set -o orrexit

bundle install
bundle exec rails db:migrate
