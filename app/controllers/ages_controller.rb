class AgesController < ApplicationController

  before_action do
    #adminでない場合、indexにリダイレクト
    if !session[:member_admin]
      redirect_to consts_path()
    end

    # ConstTBLに登録されている総人口取得
    @total_population = Const.find_by(key: "TOTAL_POPULATION")
  end

  def new
    @age_and_genders = Age.new()

    # 初期表示は0に設定する
    # 女性
    @age_and_genders.F1910 = 0
    @age_and_genders.F1920 = 0
    @age_and_genders.F1930 = 0
    @age_and_genders.F1940 = 0
    @age_and_genders.F1950 = 0
    @age_and_genders.F1960 = 0
    @age_and_genders.F1970 = 0
    @age_and_genders.F1980 = 0
    @age_and_genders.F1990 = 0
    @age_and_genders.F2000 = 0
    @age_and_genders.F2010 = 0
    # 男性
    @age_and_genders.M1910 = 0
    @age_and_genders.M1920 = 0
    @age_and_genders.M1930 = 0
    @age_and_genders.M1940 = 0
    @age_and_genders.M1950 = 0
    @age_and_genders.M1960 = 0
    @age_and_genders.M1970 = 0
    @age_and_genders.M1980 = 0
    @age_and_genders.M1990 = 0
    @age_and_genders.M2000 = 0
    @age_and_genders.M2010 = 0
  end

  def create
    @age_and_genders = Age.new(age_params)

    #入力値チェック。総人口と値が等しくなければエラー
    if !check(@age_and_genders)
      render 'new'
      return
    end

    if @age_and_genders.save
      redirect_to consts_path
    else
      render 'new'
    end
  end

  #更新
  def edit
    @age_and_genders = Age.order("id").first
  end

  def update
    @age_and_genders = Age.order("id").first
    @age_and_genders.assign_attributes(age_params)

    #入力値チェック。総人口と値が等しくなければエラー
    if !check(@age_and_genders)
      render 'edit'
      return
    end

    if @age_and_genders.save
      redirect_to consts_path
    else
      render 'edit'
    end
  end

  #年齢を求める
  def get_age(target_year, born_year_start, born_year_end)
    #born_year_startを軸に
    if born_year_start != nil
      $first = (target_year - born_year_start).to_s
    else
      $first = ""
    end

    #born_year_end
    if born_year_end != nil
      $second = (target_year - born_year_end).to_s
      if born_year_start != nil
        $second = $second << "～"
      end
    else
      $second = ""
    end

    $ret = $second << $first

    return $ret
  end

  def check(age_and_genders)
    #nilの値は0とする
    if age_and_genders.F1910 == nil
      age_and_genders.F1910 = 0
    end
    if age_and_genders.F1920 == nil
      age_and_genders.F1920 = 0
    end
    if age_and_genders.F1930 == nil
      age_and_genders.F1930 = 0
    end
    if age_and_genders.F1940 == nil
      age_and_genders.F1940 = 0
    end
    if age_and_genders.F1950 == nil
      age_and_genders.F1950 = 0
    end
    if age_and_genders.F1960 == nil
      age_and_genders.F1960 = 0
    end
    if age_and_genders.F1970 == nil
      age_and_genders.F1970 = 0
    end
    if age_and_genders.F1980 == nil
      age_and_genders.F1980 = 0
    end
    if age_and_genders.F1990 == nil
      age_and_genders.F1990 = 0
    end
    if age_and_genders.F2000 == nil
      age_and_genders.F2000 = 0
    end
    if age_and_genders.F2010 == nil
      age_and_genders.F2010 = 0
    end
    if age_and_genders.M1910 == nil
      age_and_genders.M1910 = 0
    end
    if age_and_genders.M1920 == nil
      age_and_genders.M1920 = 0
    end
    if age_and_genders.M1930 == nil
      age_and_genders.M1930 = 0
    end
    if age_and_genders.M1940 == nil
      age_and_genders.M1940 = 0
    end
    if age_and_genders.M1950 == nil
      age_and_genders.M1950 = 0
    end
    if age_and_genders.M1960 == nil
      age_and_genders.M1960 = 0
    end
    if age_and_genders.M1970 == nil
      age_and_genders.M1970 = 0
    end
    if age_and_genders.M1980 == nil
      age_and_genders.M1980 = 0
    end
    if age_and_genders.M1990 == nil
      age_and_genders.M1990 = 0
    end
    if age_and_genders.M2000 == nil
      age_and_genders.M2000 = 0
    end
    if age_and_genders.M2010 == nil
      age_and_genders.M2010 = 0
    end

    # 全入力エリア合計が
    @age_total = age_and_genders.F1910 \
                + age_and_genders.F1920 \
                + age_and_genders.F1930 \
                + age_and_genders.F1940 \
                + age_and_genders.F1950 \
                + age_and_genders.F1960 \
                + age_and_genders.F1970 \
                + age_and_genders.F1980 \
                + age_and_genders.F1990 \
                + age_and_genders.F2000 \
                + age_and_genders.F2010 \
                + age_and_genders.M1910 \
                + age_and_genders.M1920 \
                + age_and_genders.M1930 \
                + age_and_genders.M1940 \
                + age_and_genders.M1950 \
                + age_and_genders.M1960 \
                + age_and_genders.M1970 \
                + age_and_genders.M1980 \
                + age_and_genders.M1990 \
                + age_and_genders.M2000 \
                + age_and_genders.M2010
    if @age_total == @total_population.value
      return true
    end
    return false
  end

  private def age_params
    attrs = [
      :F1910,
      :F1920,
      :F1930,
      :F1940,
      :F1950,
      :F1960,
      :F1970,
      :F1980,
      :F1990,
      :F2000,
      :F2010,
      :M1910,
      :M1920,
      :M1930,
      :M1940,
      :M1950,
      :M1960,
      :M1970,
      :M1980,
      :M1990,
      :M2000,
      :M2010
    ]
    params.require(:age).permit(attrs)
  end

end
