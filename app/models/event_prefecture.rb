class EventPrefecture < ApplicationRecord
  with_options presence: true do
    with_options numericality: {only_integer: true, greater_than: -10000000000, less_than: 10000000000} do
      #人口増減
      validates :Hokkaido
      validates :Aomori
      validates :Iwate
      validates :Miyagi
      validates :Akita
      validates :Yamagata
      validates :Fukushima
      validates :Ibaraki
      validates :Tochigi
      validates :Gunma
      validates :Saitama
      validates :Chiba
      validates :Tokyo
      validates :Kanagawa
      validates :Niigata
      validates :Toyama
      validates :Ishikawa
      validates :Fukui
      validates :Yamanashi
      validates :Nagano
      validates :Gifu
      validates :Shizuoka
      validates :Aichi
      validates :Mie
      validates :Shiga
      validates :Kyoto
      validates :Osaka
      validates :Hyogo
      validates :Nara
      validates :Wakayama
      validates :Tottori
      validates :Shimane
      validates :Okayama
      validates :Hiroshima
      validates :Yamaguchi
      validates :Tokushima
      validates :Kagawa
      validates :Ehime
      validates :Kochi
      validates :Fukuoka
      validates :Saga
      validates :Nagasaki
      validates :Kumamoto
      validates :Oita
      validates :Miyazaki
      validates :Kagoshima
      validates :Okinawa
      validates :Others
    end
  end
end
