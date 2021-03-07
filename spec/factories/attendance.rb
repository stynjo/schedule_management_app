FactoryBot.define do
  factory :attendance do
    user_id { 1 }
    started_at { 'Mon, 01 Feb 2021 18:00:00 JST +09:00' }
    finished_at { 'Mon, 01 Feb 2021 20:00:00 JST +09:00' }
  end
end