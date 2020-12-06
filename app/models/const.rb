class Const < ApplicationRecord
  # 総人口
  validates :value, presence: true,
    format: {with: /\A[0-9]+\z/,
            allow_blank: true},
    length: {maximum: 10}
end
