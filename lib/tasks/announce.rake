require "slack"

namespace :announce do
  desc "当日の予約一覧を通知します。"
  task todays_reservation: :environment do
    `echo "announce:todays_reservation start!" >> /tmp/test`
    puts ENV['SLACK_TOKEN']
    Slack.configure do |config|
      config.token = ENV['SLACK_TOKEN']
    end

    today = DateTime.now.in_time_zone('Tokyo')
    reserves = Reserve.where(reservation_date: today.all_day)
    reserve_time_hash = %w[18 19 20 21 22 23].map { |i| [ i.to_s, 0 ] }.to_h
    reserves.each do |reserve|
      (reserve.reservation_start_time.hour..reserve.reservation_end_time.hour).each do |hour|
        reserve_time_hash[hour.to_s] += reserve.number_of_people
      end
    end
    Slack.chat_postMessage(text: "#{today.year}/#{today.month}/#{today.day}日 今日の予約一覧です！", channel: '#general')
    Slack.chat_postMessage(text: "18時: #{reserve_time_hash["18"]}名", channel: '#general')
    Slack.chat_postMessage(text: "19時: #{reserve_time_hash["19"]}名", channel: '#general')
    Slack.chat_postMessage(text: "20時: #{reserve_time_hash["20"]}名", channel: '#general')
    Slack.chat_postMessage(text: "21時: #{reserve_time_hash["21"]}名", channel: '#general')
    Slack.chat_postMessage(text: "22時: #{reserve_time_hash["22"]}名", channel: '#general')
    Slack.chat_postMessage(text: "23時: #{reserve_time_hash["23"]}名", channel: '#general')
  end
end