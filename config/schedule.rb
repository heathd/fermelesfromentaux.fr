set :output, File.dirname(__FILE__) + "/../../shared/log/cron.log"

every 3.minutes do
  rake "update"
end
