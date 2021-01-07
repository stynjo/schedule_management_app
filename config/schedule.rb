require File.expand_path('../config/environment', __dir__)
rails_env = ENV['RAILS_ENV'] || :development
set :environment, rails_env

def to_utc(src)
  Time.zone.parse(src).utc.strftime('%H:%M')
end

every :day, at: to_utc("7:35 pm") do
  rake 'announce:todays_reservation'
end
