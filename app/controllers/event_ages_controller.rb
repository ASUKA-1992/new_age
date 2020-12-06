class EventAgesController < CsvsController

  def new
    # 出来事取得
    @target_event = Event.find_by(id: params[:event_id])

    #該当イベントがsessionに格納されているユーザーIDと同じか確認。
    #違ったら一覧画面にリダイレクト
    if !session[:member_admin] && (!@target_event.present? || @target_event.member_id != session[:member_id])
      #一覧画面へリダイレクト
      redirect_to events_path()
      return
    end

    #年だけを取得
    @event_year = @target_event.date.year.to_i

    @age_and_genders = EventAge.new()
    @age_and_genders.event_id = @target_event.id

    @age_and_genders.total = @target_event.population_change
    set_zero(@age_and_genders)

    #前のデータ取得
    @before_data =get_before_data(@target_event)
  end

  def set_zero(age_and_genders)
    # 初期表示は0に設定する
    # 女性
    age_and_genders.F1910 = 0
    age_and_genders.F1920 = 0
    age_and_genders.F1930 = 0
    age_and_genders.F1940 = 0
    age_and_genders.F1950 = 0
    age_and_genders.F1960 = 0
    age_and_genders.F1970 = 0
    age_and_genders.F1980 = 0
    age_and_genders.F1990 = 0
    age_and_genders.F2000 = 0
    age_and_genders.F2010 = 0
    # 男性
    age_and_genders.M1910 = 0
    age_and_genders.M1920 = 0
    age_and_genders.M1930 = 0
    age_and_genders.M1940 = 0
    age_and_genders.M1950 = 0
    age_and_genders.M1960 = 0
    age_and_genders.M1970 = 0
    age_and_genders.M1980 = 0
    age_and_genders.M1990 = 0
    age_and_genders.M2000 = 0
    age_and_genders.M2010 = 0
  end

  #前のデータ取得
  def get_before_data(event)
    #有効全データ取得
    data_arr = make_arr()

    #有効全データの該当イベントのキーナンバー取得
    before_data_index = 0
    data_arr.each do |data|
      #最初のデータは省略
      if data["event_id"].to_s == event.id.to_s
        before_data_index = data["no"] - 1
        break
      end
    end
    return data_arr[before_data_index]
  end

  def create
    @age_and_genders = EventAge.new(event_age_params)

    #入力値totalが0の場合、値を登録を行わない
    #if @age_and_genders.total == 0
    #  redirect_to event_path(id: @age_and_genders.event_id)
    #  return
    #end

    #入力値チェック
    ret_check = check(@age_and_genders)

    if @age_and_genders.save
      #総人口と値が等しくない場合、該当eventレコードの人口増減を更新する
      if !ret_check
        con = ActiveRecord::Base.connection
        $q = "UPDATE events SET population_change = " + @age_and_genders.total.to_s + " where id = " + @age_and_genders.event_id.to_s
        con.execute($q)
      end
      redirect_to event_path(id: @age_and_genders.event_id)
    else
      redirect_to new_event_age_path(event_id: @age_and_genders.event_id), flash: { error:"入力できる値は-9,999,999,999～9,999,999,999です" }
    end
  end

  #更新
  def edit
    @target_event = Event.find_by(id: params["event_id"])

    #該当イベントがsessionに格納されているユーザーIDと同じか確認。
    #違ったら一覧画面にリダイレクト
    if !session[:member_admin] && (!@target_event.present? || @target_event.member_id != session[:member_id])
      #一覧画面へリダイレクト
      redirect_to events_path()
      return
    end

    #年だけを取得
    @event_year = @target_event.date.year.to_i

    @age_and_genders = EventAge.find_by(event_id: params["event_id"])
    @age_and_genders.total = @target_event.population_change

    #前のデータ取得
    @before_data =get_before_data(@target_event)
  end

  def update
    @age_and_genders = EventAge.find(params[:id])
    @age_and_genders.assign_attributes(event_age_params)

    con = ActiveRecord::Base.connection

    #入力値totalが0の場合、該当レコード削除
    if @age_and_genders.total == 0
      #入力値チェック。総人口と値が等しくない場合、該当eventレコードの人口増減を更新する
      if !check(@age_and_genders)
        $q1 = "UPDATE events SET population_change = 0 where id = " + @age_and_genders.event_id.to_s
        con.execute($q1)
      end

      $q2 = "DELETE FROM event_ages WHERE event_id=" << (@age_and_genders.event_id.to_s)
      con.execute($q2)
      redirect_to event_path(id: @age_and_genders.event_id)
      return
    end

    #入力値チェック
    ret_check = check(@age_and_genders)

    if @age_and_genders.save
      #総人口と値が等しくない場合、該当eventレコードの人口増減を更新する
      if !ret_check
        $q1 = "UPDATE events SET population_change = " + @age_and_genders.total.to_s + " where id = " + @age_and_genders.event_id.to_s
        con.execute($q1)
      end

      redirect_to event_path(id: @age_and_genders.event_id)
    else
      redirect_to edit_event_age_path(event_id: @age_and_genders.event_id), flash: { error:"入力できる値は-9,999,999,999～9,999,999,999です" }
    end
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

    # 全入力エリア合計取得
    @age_total = get_total(age_and_genders)
    if @age_total == age_and_genders.total
      return true
    end
    # totalを新しい値に更新
    age_and_genders.total = @age_total
    return false
  end

  def get_total(age_and_genders)
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

  private def event_age_params
    attrs = [
      :event_id,
      :total,
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
    params.require(:event_age).permit(attrs)
  end
end
