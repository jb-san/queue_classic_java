source "http://rubygems.org"

gem "rake"

gemspec

group :test do
  gem "turn"
  gem "minitest"
end

platform :mri do
  gem 'pg'
end

platform :jruby do
  gem 'jdbc-postgres'
end
