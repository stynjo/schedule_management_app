require "slack"

Slack.configure do |config|
  config.token = 'xoxb-1591388005351-1618805748065-lYSj82SQgjQPfWqlW28MQQPz'
end

Slack.chat_postMessage(text: 'TEST!', channel: '#general')