class EventsController < ApplicationController
  before_action :login_required

  def index
    #管理者かどうか
    @admin_flg = session[:member_admin]

    if @admin_flg

      #メンバーフィルタ作成
      @members = Member.pluck(:name, :id)
      @members.unshift("") #先頭に空データ追加

      #セッションに格納してあるフィルターID取得
      if session[:filter_member_id] == nil || session[:filter_member_id] == ''
        #全出来事を取得
        @events = Event.order("member_id", "date")
      else
        #該当メンバのデータのみ取得
        @events = Event.where(member_id: session[:filter_member_id]).order("date")
      end

    else
      #一般メンバーの場合、自分の出来事だけ取得
      @events = Event.where(member_id: session[:member_id]).order("date")
    end

    #イベントが1件もない場合、以降の処理を実施しない
    if !@events.present?
      return
    end

    #2011-01-01のレコードがあるか確認
    @is_exists_first_day = false
    if @events[0].date.to_s == "2011-01-01"
      @is_exists_first_day = true
    end

  end

  # 詳細表示
  def show
    @event = Event.find(params[:id])

    #該当イベントがsessionに格納されているユーザーIDと同じか確認。
    #違ったら一覧画面にリダイレクト
    if !session[:member_admin] && @event.member_id != session[:member_id]
      #一覧画面へリダイレクト
      redirect_to action: 'index'
      return
    end

    #event_agesTBLに出来事に紐づくデータがあるか探す
    @event_age = EventAge.find_by(event_id: params[:id])
    #event_prefectureTBLに出来事に紐づくデータがあるか探す
    @event_prefecture = EventPrefecture.find_by(event_id: params[:id])

    #50%沈没都道府県を日本語変換
    #カンマ区切り都道府県をリスト化
    @half_prefectures = ""
    if @event.half_sinking != nil
      @half_prefectures = get_prefecture_str(@event.half_sinking)
    end

    #沈没都道府県を日本語変換
    #カンマ区切り都道府県をリスト化
    @prefectures = ""
    if @event.sinking != nil
      @prefectures = get_prefecture_str(@event.sinking)
    end

    #一部汚染都道府県を日本語変換
    #カンマ区切り都道府県をリスト化
    @half_pollution = ""
    if @event.half_pollution != nil
      @half_pollution = get_prefecture_str(@event.half_pollution)
    end

    #全域汚染都道府県を日本語変換
    #カンマ区切り都道府県をリスト化
    @pollution = ""
    if @event.pollution != nil
      @pollution = get_prefecture_str(@event.pollution)
    end

    #前へ/次へボタン作成
    #まずは全イベントを日付順で取得
    if @admin_flg
      #管理者の場合、全出来事を取得
      @events = Event.order("member_id", "date")
    else
      #一般メンバーの場合、自分の出来事だけ取得
      @events = Event.where(member_id: session[:member_id]).order("date")
    end
    #全イベントでループし、前のIDと次のIDを取得
    @events.each_with_index do |event_wk, i|
      if event_wk.id.to_s == params[:id]
        #最初のデータの場合、beforeでは前ではなく表示している出来事へ遷移させる
        if i == 0
          @event_before = @events[i]
        else
          @event_before = @events[i - 1]
        end

        #最後のデータの場合、nextでは次ではなく表示している出来事へ遷移させる
        if i == @events.length-1
          @event_next = @events[i]
        else
          @event_next = @events[i + 1]
        end

        break
      end
    end

    #管理者フラグ取得
    @admin_flg = session[:member_admin]

  end

  #都道府県スラッシュ区切り取得
  def get_prefecture_str(str)
    #末尾にカンマがあるので削除
    @wk_str = str.chop
    @wk_arr = @wk_str.split(",")
    wk = ""
    @wk_arr.each do |prefecture_code|
      #都道府県日本語名を取得
      @prefecture_jpn = convert_prefecture(prefecture_code)
      #画面表示用文字列生成
      if wk.blank?
        wk = @prefecture_jpn
      else
        wk = wk + " / " + @prefecture_jpn
      end
    end
    return wk
  end

  def new
    @event = Event.new()
    #初期値設定
    @event.is_fake = false
    @event.is_active = true
    @event.population_change = 0
    @event.date = "2011-01-01"

    #管理者の場合のみ、メンバーリスト取得
    @admin_flg = session[:member_admin]
    if @admin_flg
      @members = Member.pluck(:name, :id)
    end
  end

  def create
    @event = Event.new(events_params)
    @event.event_type = 0
    @event.member_id = session[:member_id]

    #管理者でない場合のみ、デフォルトフラグをfalseに
    @admin_flg = session[:member_admin]
    if !@admin_flg
      @event.delault_flg = false
    end

    if @event.save
      redirect_to action: 'index'
    else
      if @admin_flg
        @members = Member.pluck(:name, :id)
      end
      render 'new'
    end
  end

  #更新
  def edit
    @event = Event.find(params[:id])

    #該当イベントがsessionに格納されているユーザーIDと同じか確認。
    #違ったら一覧画面にリダイレクト
    if !session[:member_admin] && (!@event.present? || @event.member_id != session[:member_id])
      #一覧画面へリダイレクト
      redirect_to action: 'index'
      return
    end

    #管理者の場合のみ、メンバーリスト取得
    @admin_flg = session[:member_admin]
    if @admin_flg
      @members = Member.pluck(:name, :id)

      #該当イベントの所有メンバーを先頭にする
      @members.each do |member|
        if member[1] == @event.member_id
          @members.delete(member) #まずは該当要素を削除
          @members.unshift(member) #先頭に要素を追加
          break
        end
      end
    end
  end

  def update
    @event = Event.find(params[:id])
    @event.assign_attributes(events_params)
    #人口増減に値がない場合、0を入れる
    if @event.population_change == nil || @event.population_change == ""
      @event.population_change = 0
    end

    #管理者の場合のみ、member_id更新機能アリ
    admin_flg = session[:member_admin]
    if admin_flg
      @event.member_id = params[:member_id]
    end

    if @event.save
      #犠牲者が0の場合、紐づくevent_ageのレコードも削除する
      if @event.population_change == 0
        con = ActiveRecord::Base.connection
        $q = "DELETE FROM event_ages WHERE event_id=" << params[:id]
        con.execute($q)
      end
      redirect_to event_path
    else
      render "edit"
    end
  end

  def destroy
    con = ActiveRecord::Base.connection
    # イベント、年齢男女別犠牲者、都道府県別犠牲者を削除
    $q1 = "DELETE FROM events WHERE id=" << (params[:id])
    con.execute($q1)
    $q2 = "DELETE FROM event_ages WHERE event_id=" << (params[:id])
    con.execute($q2)
    $q3 = "DELETE FROM event_prefectures WHERE event_id=" << (params[:id])
    con.execute($q3)

    #一覧画面へリダイレクト
    redirect_to action: 'index'
  end

  #年間人口増減登録
  def year_new
    #adminでない場合、indexにリダイレクト
    if !session[:member_admin]
      redirect_to events_path()
    end

    @event = Event.new()
    #初期値設定
    @event.date = "2011-12-31"
  end

  def year_create
    @event = Event.new(events_params)
    #自動的に登録する値を設定
    @event.event_type = 1
    @event.is_fake = false
    @event.is_active = true
    @event.population_change = 9999
    @event.delault_flg = true
    @event.member_id = session[:member_id]

    @event.title = "年間人口増減 " + @event.date.year.to_s
    @event.detail = "年間人口増減"

    #既に同年の年間人口増減が存在する場合（デフォルトに限る！）、以前のものを削除する
    con = ActiveRecord::Base.connection
    $q = "DELETE FROM events WHERE delault_flg = true and event_type = \"1\" and date =\"" << @event.date.to_s << "\""
    con.execute($q)

    if @event.save
      redirect_to action: 'index'
    else
      render 'year_new'
    end
  end

  # タイプの値取得
  def get_value_type(type)
    if type == 0
      return "出来事"
    end
    return "年間"
  end

  # フラグの値取得
  def get_flg_value(is_fake)
    if is_fake == false
      return "-"
    end
    return "○"
  end

  #男女・年齢別増減が正しく登録されているか
  def exist_event_data(id, db_neme)
    #該当イベント情報取得
    @event = Event.find(id)

    #人口総増減が0でない場合、以下の処理実施
    if @event.population_change != 0

      #該当イベントに紐づくレコードが該当DBに存在するか
      if db_neme == "event_age"
        @target = EventAge.find_by(event_id: id)
      else
        @target = EventPrefecture.find_by(event_id: id)
      end
      #存在しない場合
      if !@target.present?
        return set_puls(@event.population_change)
        #return "none"
      end

      if @event.population_change != @target.total
        #存在するが増減数に差異がある場合、"差異あり"を返却
        diff = @event.population_change - @target.total
        return set_puls(diff)
        #return "difference"
      else
        #正しい場合
        return "±0"
        #return "correct"
      end

    else
      #人口総増減が0の場合、居住地別人口で人の移動が存在するか確認
      if db_neme == "event_age"
        @target = EventAge.find_by(event_id: id)
      else
        @target = EventPrefecture.find_by(event_id: id)
      end

      #存在しない場合
      if !@target.present?
        return "±0"
        #return "unnecessary"
      else
        if @target.total == 0
          return "±0"
          #return "correct"
        else
          diff = @event.population_change - @target.total
          return set_puls(diff)
          #return "difference"
        end
      end
    end
    return "±0"
    #return "unnecessary"
  end

  #整数の頭に「＋」を加える
  def set_puls(num)
    if 0 < num
      return "+" + num.to_s
    end
    return num
  end

  # 有効でない出来事にグレーアウト用クラスを返却
  def get_row_class(event)
    if !available_event(event, true)
      return "gray_out"
    end
    return ""
  end

  # 有効な出来事か確認
  # フラグがfalseの場合、2011-01-01のレコード確認をしない
  def available_event(event, first_dat_chk_flg)

    #2011-01-01のレコードがあるか確認
    if first_dat_chk_flg
      if !@is_exists_first_day
        return false
      end
    end

    #無効の場合、false
    if !event.is_active
      return false
    end

    #event_ageTBLが不正の場合、false
    @wk = exist_event_data(event.id, "event_age")
    #if @wk == "none" || @wk == "difference"
    if @wk != "±0"
      return false
    end

    #event_prefectureTBLが不正の場合、false
    @wk = exist_event_data(event.id, "event_prefecture")
    #if @wk == "none" || @wk == "difference"
    if @wk != "±0"
      return false
    end

    return true
  end

  #沈没都道府県名変換
  def convert_prefecture(prefecture_code)
    case prefecture_code
    when "1-Hokkaido" then
      return "北海道"
    when "2-Aomori" then
      return "青森県"
    when "3-Iwate" then
      return "岩手県"
    when "4-Akita" then
      return "秋田県"
    when "5-Miyagi" then
      return "宮城県"
    when "6-Yamagata" then
      return "山形県"
    when "7-Fukushima" then
      return "福島県"
    when "8-Ibaraki" then
      return "茨城県"
    when "9-Tochigi" then
      return "栃木県"
    when "10-Gunma" then
      return "群馬県"
    when "11-Saitama" then
      return "埼玉県"
    when "12-Chiba" then
      return "千葉県"
    when "13-Tokyo" then
      return "東京都"
    when "14-Kanagawa" then
      return "神奈川県"
    when "15-Niigata" then
      return "新潟県"
    when "16-Toyama" then
      return "富山県"
    when "17-Ishikawa" then
      return "石川県"
    when "18-Fukui" then
      return "福井県"
    when "19-Yamanashi" then
      return "山梨県"
    when "20-Nagano" then
      return "長野県"
    when "21-Gifu" then
      return "岐阜県"
    when "22-Shizuoka" then
      return "静岡県"
    when "23-Aichi" then
      return "愛知県"
    when "24-Mie" then
      return "三重県"
    when "25-Shiga" then
      return "滋賀県"
    when "26-Kyoto" then
      return "京都府"
    when "27-Osaka" then
      return "大阪府"
    when "28-Hyogo" then
      return "兵庫県"
    when "29-Nara" then
      return "奈良県"
    when "30-Wakayama" then
      return "和歌山県"
    when "31-Tottori" then
      return "鳥取県"
    when "32-Shimane" then
      return "島根県"
    when "33-Okayama" then
      return "岡山県"
    when "34-Hiroshima" then
      return "広島県"
    when "35-Yamaguchi" then
      return "山口県"
    when "36-Tokushima" then
      return "徳島県"
    when "37-Kagawa" then
      return "香川県"
    when "38-Ehime" then
      return "愛媛県"
    when "39-Kochi" then
      return "高知県"
    when "40-Fukuoka" then
      return "福岡県"
    when "41-Saga" then
      return "佐賀県"
    when "42-Nagasaki" then
      return "長崎県"
    when "43-Kumamoto" then
      return "熊本県"
    when "44-Oita" then
      return "大分県"
    when "45-Miyazaki" then
      return "宮崎県"
    when "46-Kagoshima" then
      return "鹿児島県"
    else
      return "沖縄県"
    end
    return ""
  end

  #人口増減不正
  def return_alert_class(int)
    if int != 0
      return "alert_color"
    end
    return ""
  end

  #値があればオレンジ網掛け
  def return_alert_class_str(str)
    if str.present?
      return "alert_color"
    end
    return ""
  end

  #管理者用 メンバーフィルタ
  def set_mamber_filter
    #空データが選択された場合、フィルターセッションを破棄
    if params[:filter_member_id] == ''
      session.delete(:filter_member_id)
    else
      #セッションにフルターID追加
      session[:filter_member_id] = params[:filter_member_id]
    end
    redirect_to action: 'index'
  end

  #2011-01-01でidが一番新しいデータの場合、削除と非活性にできない
  def check_first_data(event)
    #新規か否か判定。新規の場合はtrue返却
    if event.id == nil
      return true
    end

    #2011年1月1日が確認
    if event.date.to_s != "2011-01-01"
      return true
    end

    #2011年1月1日のデータが2つ以上あるか確認
    events = Event.where(member_id: session[:member_id], date: "2011-01-01").order("id")
    if events.length < 2
      #データが1つの場合、無条件でfalseを返却
      return false
    end

    #データが2つ以上ある場合、idが一番若いもののみ、falseを返却
    if events[0].id == event.id
      return false
    end

    return true
  end

  #年間人口増減デフォルト復元
  def restor_default

    #該当年間人口増減のデフォルトイベント取得
    default_event = Event.find_by(title: params[:title], delault_flg: true, is_active: true)
    #event_agesTBLの出来事に紐づくデータ取得
    default_event_age = EventAge.find_by(event_id: default_event.id)
    #event_prefectureTBLにの出来事に紐づくデータ取得
    default_event_prefecture = EventPrefecture.find_by(event_id: default_event.id)

    #デフォルトイベントの値でevent_ages更新
    taeget_event_age = EventAge.find_by(event_id: params[:id]) #更新するデータ
    taeget_event_age.total = default_event_age.total
    taeget_event_age.F1910 = default_event_age.F1910
    taeget_event_age.F1920 = default_event_age.F1920
    taeget_event_age.F1930 = default_event_age.F1930
    taeget_event_age.F1940 = default_event_age.F1940
    taeget_event_age.F1950 = default_event_age.F1950
    taeget_event_age.F1960 = default_event_age.F1960
    taeget_event_age.F1970 = default_event_age.F1970
    taeget_event_age.F1980 = default_event_age.F1980
    taeget_event_age.F1990 = default_event_age.F1990
    taeget_event_age.F2000 = default_event_age.F2000
    taeget_event_age.F2010 = default_event_age.F2010
    taeget_event_age.M1910 = default_event_age.M1910
    taeget_event_age.M1920 = default_event_age.M1920
    taeget_event_age.M1930 = default_event_age.M1930
    taeget_event_age.M1940 = default_event_age.M1940
    taeget_event_age.M1950 = default_event_age.M1950
    taeget_event_age.M1960 = default_event_age.M1960
    taeget_event_age.M1970 = default_event_age.M1970
    taeget_event_age.M1980 = default_event_age.M1980
    taeget_event_age.M1990 = default_event_age.M1990
    taeget_event_age.M2000 = default_event_age.M2000
    taeget_event_age.M2010 = default_event_age.M2010
    #更新実行
    taeget_event_age.save

    #デフォルトイベントの値でevent_prefecture更新
    taeget_event_prefecture = EventPrefecture.find_by(event_id: params[:id]) #更新するデータ
    taeget_event_prefecture.total     = default_event_prefecture.total
    taeget_event_prefecture.Hokkaido  = default_event_prefecture.Hokkaido
    taeget_event_prefecture.Aomori    = default_event_prefecture.Aomori
    taeget_event_prefecture.Iwate     = default_event_prefecture.Iwate
    taeget_event_prefecture.Miyagi    = default_event_prefecture.Miyagi
    taeget_event_prefecture.Akita     = default_event_prefecture.Akita
    taeget_event_prefecture.Yamagata  = default_event_prefecture.Yamagata
    taeget_event_prefecture.Fukushima = default_event_prefecture.Fukushima
    taeget_event_prefecture.Ibaraki   = default_event_prefecture.Ibaraki
    taeget_event_prefecture.Tochigi   = default_event_prefecture.Tochigi
    taeget_event_prefecture.Gunma     = default_event_prefecture.Gunma
    taeget_event_prefecture.Saitama   = default_event_prefecture.Saitama
    taeget_event_prefecture.Chiba     = default_event_prefecture.Chiba
    taeget_event_prefecture.Tokyo     = default_event_prefecture.Tokyo
    taeget_event_prefecture.Kanagawa  = default_event_prefecture.Kanagawa
    taeget_event_prefecture.Niigata   = default_event_prefecture.Niigata
    taeget_event_prefecture.Toyama    = default_event_prefecture.Toyama
    taeget_event_prefecture.Ishikawa  = default_event_prefecture.Ishikawa
    taeget_event_prefecture.Fukui     = default_event_prefecture.Fukui
    taeget_event_prefecture.Yamanashi = default_event_prefecture.Yamanashi
    taeget_event_prefecture.Nagano    = default_event_prefecture.Nagano
    taeget_event_prefecture.Gifu      = default_event_prefecture.Gifu
    taeget_event_prefecture.Shizuoka  = default_event_prefecture.Shizuoka
    taeget_event_prefecture.Aichi     = default_event_prefecture.Aichi
    taeget_event_prefecture.Mie       = default_event_prefecture.Mie
    taeget_event_prefecture.Shiga     = default_event_prefecture.Shiga
    taeget_event_prefecture.Kyoto     = default_event_prefecture.Kyoto
    taeget_event_prefecture.Osaka     = default_event_prefecture.Osaka
    taeget_event_prefecture.Hyogo     = default_event_prefecture.Hyogo
    taeget_event_prefecture.Nara      = default_event_prefecture.Nara
    taeget_event_prefecture.Wakayama  = default_event_prefecture.Wakayama
    taeget_event_prefecture.Tottori   = default_event_prefecture.Tottori
    taeget_event_prefecture.Shimane   = default_event_prefecture.Shimane
    taeget_event_prefecture.Okayama   = default_event_prefecture.Okayama
    taeget_event_prefecture.Hiroshima = default_event_prefecture.Hiroshima
    taeget_event_prefecture.Yamaguchi = default_event_prefecture.Yamaguchi
    taeget_event_prefecture.Tokushima = default_event_prefecture.Tokushima
    taeget_event_prefecture.Kagawa    = default_event_prefecture.Kagawa
    taeget_event_prefecture.Ehime     = default_event_prefecture.Ehime
    taeget_event_prefecture.Kochi     = default_event_prefecture.Kochi
    taeget_event_prefecture.Fukuoka   = default_event_prefecture.Fukuoka
    taeget_event_prefecture.Saga      = default_event_prefecture.Saga
    taeget_event_prefecture.Nagasaki  = default_event_prefecture.Nagasaki
    taeget_event_prefecture.Kumamoto  = default_event_prefecture.Kumamoto
    taeget_event_prefecture.Oita      = default_event_prefecture.Oita
    taeget_event_prefecture.Miyazaki  = default_event_prefecture.Miyazaki
    taeget_event_prefecture.Kagoshima = default_event_prefecture.Kagoshima
    taeget_event_prefecture.Okinawa   = default_event_prefecture.Okinawa
    taeget_event_prefecture.Others    = default_event_prefecture.Others
    #更新実行
    taeget_event_prefecture.save

    #イベント更新
    con = ActiveRecord::Base.connection
    $q = "UPDATE events SET population_change = " + default_event.population_change.to_s + " where id = " + params[:id]
    con.execute($q)

    redirect_to event_path(id: params[:id])
  end

  private def events_params
    attrs = [
      :is_fake,
      :is_active,
      :date,
      :title,
      :detail,
      :population_change,
      :half_sinking,
      :sinking,
      :half_pollution,
      :pollution,
      :member_id,
      :delault_flg,
    ]
    params.require(:event).permit(attrs)
  end

end
