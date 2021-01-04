require "slack"

namespace :announce do
  desc "当日の予約一覧を通知します。"
  task todays_reservation: :environment do
    Slack.configure do |config|
      config.token = "xoxb-1591388005351-1618805748065-lYSj82SQgjQPfWqlW28MQQPz"
    end

    Slack.chat_postMessage(text: 'TEST!', channel: '#general')
    Slack.chat_postMessage(text: "last user's name: #{User.last.name}", channel: '#general')
  end
end