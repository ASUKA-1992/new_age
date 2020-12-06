class MembersController < ApplicationController

  def index
    login_required
    @members = Member.order("id")
  end

  def show
    login_required
    redirect_to action: 'index'
  end

  #公開データ取得
  def get_show_csv(member_id, ret_file_name_flg)
    #退会済みメンバーの場合は、空文字を返却
    member = Member.find(member_id)
    if member.unsbscribe_date != nil
      return ""
    end

    text_file_name = (Rails.root.join('app', 'csv', member_id.to_s)).to_s + "_member/target.txt"
    file = File.open(text_file_name,"r")
    file.each do |text|
      #頭が「202」かどうか判定
      # 頭の3文字を抽出
      top_text = text.slice(0,3)
      # 頭の3文字が「202」でなければ、空文字を返却
      unless top_text == "202"
        return ""
      end

      #ファイル名返却フラグから、返却文字列を判断
      if ret_file_name_flg
        #頭の3文字が「202」の場合、そこに書いてある文字列=csv取得
        return text
      else
        return "新しい10年間"
      end
    end
  end

  #新規作成フォーム
  def new
    @member = Member.new()
  end

  #会員の新規登録
  def create
    @member = Member.new(member_params)

    #管理者フラグ
    @member.admin = false

    if @member.save
      #新規できたメンバーのIDを取得
      new_id = Member.find_by_sql("SELECT id FROM members ORDER BY id DESC LIMIT 1")

      #デフォルトイベントを複製
      #まずはデフォルトイベント取得
      default_events = Event.where("is_active = ? AND delault_flg = ?", true, true).order(:date)
      #ループでデータ複製
      default_events.each do |loop_event|
        event = Event.new()
        event.event_type = loop_event.event_type
        event.is_fake = false
        event.is_active = true
        event.date = loop_event.date
        event.title = loop_event.title
        event.detail = loop_event.detail
        event.population_change = loop_event.population_change
        event.half_sinking = loop_event.half_sinking
        event.sinking = loop_event.sinking
        event.half_sinking = loop_event.half_sinking
        event.pollution = loop_event.pollution
        event.half_pollution = loop_event.half_pollution
        event.member_id = new_id[0].id #新しく作ったメンバーのID
        event.delault_flg = false
        #複製実行
        event.save

        #新規できたイベントのIDを取得
        query_age = "SELECT id FROM events WHERE " + new_id[0].id.to_s + " ORDER BY id DESC LIMIT 1";
        event_id = Event.find_by_sql(query_age)

        #続いて、イベントに紐づく年齢・性別別人口増減を複製
        #該当レコード取得
        default_event_age = EventAge.find_by(event_id: loop_event.id)
        if default_event_age.present?
          age_and_genders = EventAge.new()
          #イベントID
          age_and_genders.event_id = event_id[0].id
          #人口増減
          age_and_genders.total = loop_event.population_change
          # 女性
          age_and_genders.F1910 = default_event_age.F1910
          age_and_genders.F1920 = default_event_age.F1920
          age_and_genders.F1930 = default_event_age.F1930
          age_and_genders.F1940 = default_event_age.F1940
          age_and_genders.F1950 = default_event_age.F1950
          age_and_genders.F1960 = default_event_age.F1960
          age_and_genders.F1970 = default_event_age.F1970
          age_and_genders.F1980 = default_event_age.F1980
          age_and_genders.F1990 = default_event_age.F1990
          age_and_genders.F2000 = default_event_age.F2000
          age_and_genders.F2010 = default_event_age.F2010
          # 男性
          age_and_genders.M1910 = default_event_age.M1910
          age_and_genders.M1920 = default_event_age.M1920
          age_and_genders.M1930 = default_event_age.M1930
          age_and_genders.M1940 = default_event_age.M1940
          age_and_genders.M1950 = default_event_age.M1950
          age_and_genders.M1960 = default_event_age.M1960
          age_and_genders.M1970 = default_event_age.M1970
          age_and_genders.M1980 = default_event_age.M1980
          age_and_genders.M1990 = default_event_age.M1990
          age_and_genders.M2000 = default_event_age.M2000
          age_and_genders.M2010 = default_event_age.M2010
          #複製実行
          age_and_genders.save
        end

        #続いて、イベントに紐づく都道府県人口増減を複製
        #該当レコード取得
        default_prefectures = EventPrefecture.find_by(event_id:loop_event.id)
        if default_prefectures.present?
          prefectures = EventPrefecture.new()
          #イベントID
          prefectures.event_id = event_id[0].id
          #人口増減
          prefectures.total = loop_event.population_change

          #北海道・東北
          prefectures.Hokkaido = default_prefectures.Hokkaido
          prefectures.Aomori = default_prefectures.Aomori
          prefectures.Iwate = default_prefectures.Iwate
          prefectures.Miyagi = default_prefectures.Miyagi
          prefectures.Akita = default_prefectures.Akita
          prefectures.Yamagata = default_prefectures.Yamagata
          prefectures.Fukushima = default_prefectures.Fukushima
          #関東
          prefectures.Ibaraki = default_prefectures.Ibaraki
          prefectures.Tochigi = default_prefectures.Tochigi
          prefectures.Gunma = default_prefectures.Gunma
          prefectures.Saitama = default_prefectures.Saitama
          prefectures.Chiba = default_prefectures.Chiba
          prefectures.Tokyo = default_prefectures.Tokyo
          prefectures.Kanagawa = default_prefectures.Kanagawa
          #中部
          prefectures.Niigata = default_prefectures.Niigata
          prefectures.Toyama = default_prefectures.Toyama
          prefectures.Ishikawa = default_prefectures.Ishikawa
          prefectures.Fukui = default_prefectures.Fukui
          prefectures.Yamanashi = default_prefectures.Yamanashi
          prefectures.Nagano = default_prefectures.Nagano
          prefectures.Gifu = default_prefectures.Gifu
          prefectures.Shizuoka = default_prefectures.Shizuoka
          prefectures.Aichi = default_prefectures.Aichi
          #近畿
          prefectures.Mie = default_prefectures.Mie
          prefectures.Shiga = default_prefectures.Shiga
          prefectures.Kyoto = default_prefectures.Kyoto
          prefectures.Osaka = default_prefectures.Osaka
          prefectures.Hyogo = default_prefectures.Hyogo
          prefectures.Nara = default_prefectures.Nara
          prefectures.Wakayama = default_prefectures.Wakayama
          #中国・四国
          prefectures.Tottori = default_prefectures.Tottori
          prefectures.Shimane = default_prefectures.Shimane
          prefectures.Okayama = default_prefectures.Okayama
          prefectures.Hiroshima = default_prefectures.Hiroshima
          prefectures.Yamaguchi = default_prefectures.Yamaguchi
          prefectures.Tokushima = default_prefectures.Tokushima
          prefectures.Kagawa = default_prefectures.Kagawa
          prefectures.Ehime = default_prefectures.Ehime
          prefectures.Kochi = default_prefectures.Kochi
          #九州・沖縄
          prefectures.Fukuoka = default_prefectures.Fukuoka
          prefectures.Saga = default_prefectures.Saga
          prefectures.Nagasaki = default_prefectures.Nagasaki
          prefectures.Kumamoto = default_prefectures.Kumamoto
          prefectures.Oita = default_prefectures.Oita
          prefectures.Miyazaki = default_prefectures.Miyazaki
          prefectures.Kagoshima = default_prefectures.Kagoshima
          prefectures.Okinawa = default_prefectures.Okinawa
          prefectures.Others = default_prefectures.Others

          #複製実行
          prefectures.save
        end
      end

      #csvのディレクトリ作成
      dir_name = (Rails.root.join('app', 'csv', new_id[0].id.to_s + "_member")).to_s

      Dir.mkdir(dir_name)
      #続いて、デフォルトのcsvをコピー
      default_file_csv = (Rails.root.join('app', 'csv', "default.csv")).to_s
      FileUtils.cp(default_file_csv, dir_name + "/target.csv")
      #該当ファイル名を記載するテキストファイルをコピー
      default_file_txt = (Rails.root.join('app', 'csv', "target.txt")).to_s
      FileUtils.cp(default_file_txt, dir_name + "/target.txt")

      if session[:member_admin]
        #管理者の場合、メンバー一覧へ
        redirect_to action: 'index'
        return
      else
        #管理者じゃない場合、ログイン画面へ
        flash.alert = "会員登録が完了しました。登録したメールアドレスとパスワードを入力すると、ログインできます"
        render "login"
      end

    else
      render 'new'
    end
  end

  #更新
  def edit
    #adminじゃない＋paramsとセッションのメンバーIDが異なる場合、別画面遷移
    if !session[:member_admin]
      if params[:id].to_s != session[:member_id].to_s
        redirect_to action: 'index'
        return
      end
    end
    @member = Member.find(params[:id])
  end

  def update
    @member = Member.find(params[:id])
    @member.assign_attributes(member_params)

    if @member.save
      redirect_to action: 'index'
    else
      render 'edit'
    end
  end

  #パスワードリセット
  def password_reset
    @member = Member.find(params[:id])
    @member.password = "Password10"
    @member.password_confirmation = "Password10"

    #保存
    @member.save

    redirect_to action: 'index'
  end

  #会員の削除
  def destroy
    @member = Member.find(params[:id])
    @member.destroy

    #CSVディレクトリ削除
    dir_name = (Rails.root.join('app', 'csv', @member.id.to_s + "_member")).to_s
    if Dir.exist?(dir_name)
      FileUtils.rm_rf(dir_name)
    end

    #イベント削除
    events = Event.where(member_id: @member.id.to_s).order("date")
    #ループで消していく
    con = ActiveRecord::Base.connection
    events.each do |event|
      # イベント、年齢男女別犠牲者、都道府県別犠牲者を削除
      $q1 = "DELETE FROM events WHERE id=" << event.id.to_s
      con.execute($q1)
      $q2 = "DELETE FROM event_ages WHERE event_id=" << event.id.to_s
      con.execute($q2)
      $q3 = "DELETE FROM event_prefectures WHERE event_id=" << event.id.to_s
      con.execute($q3)
    end

    redirect_to action: 'index'
  end

  #退会処理
  def unsbscribe
    #ランダム文字列作成
    require 'securerandom'
    random_cd = SecureRandom.hex(8)
    #現在のメールアドレス取得
    member = Member.find(session[:member_id])
    new_member_mail = member.mail + "_" + random_cd

    #現在日時取得
    t = DateTime.now
    current_date = t.strftime("%Y/%m/%d %H:%M:%S")
    #DB接続
    con = ActiveRecord::Base.connection
    # SQL作成
    $q = "UPDATE members SET unsbscribe_date = \""+ current_date + "\", mail = \"" + new_member_mail + "\" WHERE id = " + session[:member_id].to_s
    # SQL実行。membersTBLの大会日時フラグに現在日時を入れる
    con.execute($q)

    #トップ画面に遷移
    session.delete(:member_id)
    session.delete(:member_name)
    session.delete(:admin)
    session.delete(:filter_member_id)
    redirect_to :ten_years
  end

  #ストロングパラメーター
  private def member_params
    attrs = [
      :name,
      :mail,
      :password,
      :password_confirmation
    ]
    attrs << :admin if params[:action] == "update"
    params.require(:member).permit(attrs)
  end

end
