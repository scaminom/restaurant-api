set -o orrexit

bundle install
bundle exec rails db:drop
bundle exec rails db:migrate
bundle exec rails db:seed
