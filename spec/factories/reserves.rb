FactoryBot.define do
  factory :reserve do
    reserve_name { "test" }
    number_of_people { 2 }
    reservation_start_time { 'Mon, 01 Feb 2021 18:00:00 JST +09:00' }
    reservation_end_time { 'Mon, 01 Feb 2021 20:00:00 JST +09:00' }
  end
end


