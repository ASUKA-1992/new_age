class EventAge < ApplicationRecord
  with_options presence: true do
    with_options numericality: {only_integer: true, greater_than: -10000000000, less_than: 10000000000} do
      #人口増減
      validates :F1910
      validates :F1920
      validates :F1930
      validates :F1940
      validates :F1950
      validates :F1960
      validates :F1970
      validates :F1980
      validates :F1990
      validates :F2000
      validates :F2010
      validates :M1910
      validates :M1920
      validates :M1930
      validates :M1940
      validates :M1950
      validates :M1960
      validates :M1970
      validates :M1980
      validates :M1990
      validates :M2000
      validates :M2010
    end
  end
end
