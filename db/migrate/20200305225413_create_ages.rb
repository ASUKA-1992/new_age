class CreateAges < ActiveRecord::Migration[5.2]
  def change
    create_table :ages do |t|
      t.integer :F1910, null:false  #女性1910
      t.integer :F1920, null:false  #女性1920
      t.integer :F1930, null:false  #女性1930
      t.integer :F1940, null:false  #女性1940
      t.integer :F1950, null:false  #女性1950
      t.integer :F1960, null:false  #女性1960
      t.integer :F1970, null:false  #女性1970
      t.integer :F1980, null:false  #女性1980
      t.integer :F1990, null:false  #女性1990
      t.integer :F2000, null:false  #女性2000
      t.integer :F2010, null:false  #女性2010
      t.integer :M1910, null:false  #男性1910
      t.integer :M1920, null:false  #男性1920
      t.integer :M1930, null:false  #男性1930
      t.integer :M1940, null:false  #男性1940
      t.integer :M1950, null:false  #男性1950
      t.integer :M1960, null:false  #男性1960
      t.integer :M1970, null:false  #男性1970
      t.integer :M1980, null:false  #男性1980
      t.integer :M1990, null:false  #男性1990
      t.integer :M2000, null:false  #男性2000
      t.integer :M2010, null:false  #男性2010
      t.timestamps
    end
  end
end
