class Event < ApplicationRecord
  #年月日
  validates :date, presence: true
  #タイトル
  validates :title, presence: true, length: {maximum: 25}
  #詳細
  validates :detail, length: {maximum: 200}
  #人口増減
  validates :population_change, presence: true,
    numericality: {
      only_integer: true,
      greater_than: -10000000000,
      less_than:     10000000000
  }
end
