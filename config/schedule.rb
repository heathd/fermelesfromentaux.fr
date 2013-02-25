set :output, File.dirname(__FILE__) + "/../../shared/log/cron.log"

every 15.minutes do
  rake "update"
end
