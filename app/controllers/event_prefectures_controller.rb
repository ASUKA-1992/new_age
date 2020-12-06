class EventPrefecturesController < CsvsController

  def new
    # 出来事取得
    @target_event = Event.find_by(id: params["event_id"])

    #該当イベントがsessionに格納されているユーザーIDと同じか確認。
    #違ったら一覧画面にリダイレクト
    if !session[:member_admin] && (!@target_event.present? || @target_event.member_id != session[:member_id])
      #一覧画面へリダイレクト
      redirect_to events_path()
      return
    end

    @prefectures = EventPrefecture.new()
    @prefectures.event_id = @target_event.id

    @prefectures.total = @target_event.population_change

    # 初期表示は0に設定する
    # 北海道・東北
    @prefectures.Hokkaido = 0
    @prefectures.Aomori = 0
    @prefectures.Iwate = 0
    @prefectures.Miyagi = 0
    @prefectures.Akita = 0
    @prefectures.Yamagata = 0
    @prefectures.Fukushima = 0
    # 関東
    @prefectures.Ibaraki = 0
    @prefectures.Tochigi = 0
    @prefectures.Gunma = 0
    @prefectures.Saitama = 0
    @prefectures.Chiba = 0
    @prefectures.Tokyo = 0
    @prefectures.Kanagawa = 0
    # 中部
    @prefectures.Niigata = 0
    @prefectures.Toyama = 0
    @prefectures.Ishikawa = 0
    @prefectures.Fukui = 0
    @prefectures.Yamanashi = 0
    @prefectures.Nagano = 0
    @prefectures.Gifu = 0
    @prefectures.Shizuoka = 0
    @prefectures.Aichi = 0
    # 近畿
    @prefectures.Mie = 0
    @prefectures.Shiga = 0
    @prefectures.Kyoto = 0
    @prefectures.Osaka = 0
    @prefectures.Hyogo = 0
    @prefectures.Nara = 0
    @prefectures.Wakayama = 0
    # 中国・四国
    @prefectures.Tottori = 0
    @prefectures.Shimane = 0
    @prefectures.Okayama = 0
    @prefectures.Hiroshima = 0
    @prefectures.Yamaguchi = 0
    @prefectures.Tokushima = 0
    @prefectures.Kagawa = 0
    @prefectures.Ehime = 0
    @prefectures.Kochi = 0
    # 九州・沖縄
    @prefectures.Fukuoka = 0
    @prefectures.Saga = 0
    @prefectures.Nagasaki = 0
    @prefectures.Kumamoto = 0
    @prefectures.Oita = 0
    @prefectures.Miyazaki = 0
    @prefectures.Kagoshima = 0
    @prefectures.Okinawa = 0
    @prefectures.Others = 0

    #前のデータ取得
    @before_data =get_before_data(@target_event)
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
    @prefectures = EventPrefecture.new(event_prefecture_params)

    #すべての都道府県人口増減が0の場合、値の登録を行わない
    if !check_not_all_zero(@prefectures)
      redirect_to event_path(id: @prefectures.event_id)
      return
    end

    #入力値チェック。
    ret_check = check(@prefectures)

    if @prefectures.save
      #入力値チェック。総人口と値が等しくない場合、該当eventレコードの人口増減を更新する
      if !ret_check
        con = ActiveRecord::Base.connection
        $q = "UPDATE events SET population_change = " + @prefectures.total.to_s + " where id = " + @prefectures.event_id.to_s
        con.execute($q)
      end

      redirect_to event_path(id: @prefectures.event_id)
    else
      #render "new"
      redirect_to new_event_prefecture_path(event_id: @prefectures.event_id), flash: { error:"入力できる値は-9,999,999,999～9,999,999,999です" }
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

    @prefectures = EventPrefecture.find_by(event_id: params["event_id"])
    @prefectures.total = @target_event.population_change

    #前のデータ取得
    @before_data =get_before_data(@target_event)
  end

  def update
    @prefectures = EventPrefecture.find(params[:id])
    @prefectures.assign_attributes(event_prefecture_params)

    con = ActiveRecord::Base.connection
    #すべての都道府県人口増減が0の場合、レコード削除
    if !check_not_all_zero(@prefectures)
      #入力値チェック。総人口と値が等しくない場合、該当eventレコードの人口増減を更新する
      if !check(@prefectures)
        $q1 = "UPDATE events SET population_change = 0 where id = " + @prefectures.event_id.to_s
        con.execute($q1)
      end

      $q2 = "DELETE FROM event_prefectures WHERE event_id=" << (@prefectures.event_id.to_s)
      con.execute($q2)
      redirect_to event_path(id: @prefectures.event_id)
      return
    end

    #入力値チェック。
    ret_check = check(@prefectures)

    if @prefectures.save
      #総人口と値が等しくない場合、該当eventレコードの人口増減を更新する
      if !ret_check
        $q1 = "UPDATE events SET population_change = " + @prefectures.total.to_s + " where id = " + @prefectures.event_id.to_s
        con.execute($q1)
      end

      redirect_to event_path(id: @prefectures.event_id)
    else
      #render 'edit'
      redirect_to edit_event_prefecture_path(event_id: @prefectures.event_id), flash: { error:"入力できる値は-9,999,999,999～9,999,999,999です" }
    end
  end

  def check(prefectures)
    #nilの値は0とする
    # 北海道・東北
    if prefectures.Hokkaido == nil
      prefectures.Hokkaido = 0
    end
    if prefectures.Aomori == nil
      prefectures.Aomori = 0
    end
    if prefectures.Iwate == nil
      prefectures.Iwate = 0
    end
    if prefectures.Miyagi == nil
      prefectures.Miyagi = 0
    end
    if prefectures.Akita == nil
      prefectures.Akita = 0
    end
    if prefectures.Yamagata == nil
      prefectures.Yamagata = 0
    end
    if prefectures.Fukushima == nil
      prefectures.Fukushima = 0
    end
    # 関東
    if prefectures.Ibaraki == nil
      prefectures.Ibaraki = 0
    end
    if prefectures.Tochigi == nil
      prefectures.Tochigi = 0
    end
    if prefectures.Gunma == nil
      prefectures.Gunma = 0
    end
    if prefectures.Saitama == nil
      prefectures.Saitama = 0
    end
    if prefectures.Chiba == nil
      prefectures.Chiba = 0
    end
    if prefectures.Tokyo == nil
      prefectures.Tokyo = 0
    end
    if prefectures.Kanagawa == nil
      prefectures.Kanagawa = 0
    end
    # 中部
    if prefectures.Niigata == nil
      prefectures.Niigata = 0
    end
    if prefectures.Toyama == nil
      prefectures.Toyama = 0
    end
    if prefectures.Ishikawa == nil
      prefectures.Ishikawa = 0
    end
    if prefectures.Fukui == nil
      prefectures.Fukui = 0
    end
    if prefectures.Yamanashi == nil
      prefectures.Yamanashi = 0
    end
    if prefectures.Nagano == nil
      prefectures.Nagano = 0
    end
    if prefectures.Gifu == nil
      prefectures.Gifu = 0
    end
    if prefectures.Shizuoka == nil
      prefectures.Shizuoka = 0
    end
    if prefectures.Aichi == nil
      prefectures.Aichi = 0
    end
    if prefectures.Mie == nil
      prefectures.Mie = 0
    end
    # 近畿
    if prefectures.Shiga == nil
      prefectures.Shiga = 0
    end
    if prefectures.Kyoto == nil
      prefectures.Kyoto = 0
    end
    if prefectures.Osaka == nil
      prefectures.Osaka = 0
    end
    if prefectures.Hyogo == nil
      prefectures.Hyogo = 0
    end
    if prefectures.Nara == nil
      prefectures.Nara = 0
    end
    if prefectures.Wakayama == nil
      prefectures.Wakayama = 0
    end
    # 中国・四国
    if prefectures.Tottori == nil
      prefectures.Tottori = 0
    end
    if prefectures.Shimane == nil
      prefectures.Shimane = 0
    end
    if prefectures.Okayama == nil
      prefectures.Okayama = 0
    end
    if prefectures.Hiroshima == nil
      prefectures.Hiroshima = 0
    end
    if prefectures.Yamaguchi == nil
      prefectures.Yamaguchi = 0
    end
    if prefectures.Tokushima == nil
      prefectures.Tokushima = 0
    end
    if prefectures.Kagawa == nil
      prefectures.Kagawa = 0
    end
    if prefectures.Ehime == nil
      prefectures.Ehime = 0
    end
    if prefectures.Kochi == nil
      prefectures.Kochi = 0
    end
    # 九州・沖縄
    if prefectures.Fukuoka == nil
      prefectures.Fukuoka = 0
    end
    if prefectures.Saga == nil
      prefectures.Saga = 0
    end
    if prefectures.Nagasaki == nil
      prefectures.Nagasaki = 0
    end
    if prefectures.Kumamoto == nil
      prefectures.Kumamoto = 0
    end
    if prefectures.Oita == nil
      prefectures.Oita = 0
    end
    if prefectures.Miyazaki == nil
      prefectures.Miyazaki = 0
    end
    if prefectures.Kagoshima == nil
      prefectures.Kagoshima = 0
    end
    if prefectures.Okinawa == nil
      prefectures.Okinawa = 0
    end
    if prefectures.Others == nil
      prefectures.Others = 0
    end

    # 全入力エリア合計が
    @prefecture_total = prefectures.Hokkaido \
                      + prefectures.Aomori \
                      + prefectures.Iwate \
                      + prefectures.Miyagi \
                      + prefectures.Akita \
                      + prefectures.Yamagata \
                      + prefectures.Fukushima \
                      + prefectures.Ibaraki \
                      + prefectures.Tochigi \
                      + prefectures.Gunma \
                      + prefectures.Saitama \
                      + prefectures.Chiba \
                      + prefectures.Tokyo \
                      + prefectures.Kanagawa \
                      + prefectures.Niigata \
                      + prefectures.Toyama \
                      + prefectures.Ishikawa \
                      + prefectures.Fukui \
                      + prefectures.Yamanashi \
                      + prefectures.Nagano \
                      + prefectures.Gifu \
                      + prefectures.Shizuoka \
                      + prefectures.Aichi \
                      + prefectures.Mie \
                      + prefectures.Shiga \
                      + prefectures.Kyoto \
                      + prefectures.Osaka \
                      + prefectures.Hyogo \
                      + prefectures.Nara \
                      + prefectures.Wakayama \
                      + prefectures.Tottori \
                      + prefectures.Shimane \
                      + prefectures.Okayama \
                      + prefectures.Hiroshima \
                      + prefectures.Yamaguchi \
                      + prefectures.Tokushima \
                      + prefectures.Kagawa \
                      + prefectures.Ehime \
                      + prefectures.Kochi \
                      + prefectures.Fukuoka \
                      + prefectures.Saga \
                      + prefectures.Nagasaki \
                      + prefectures.Kumamoto \
                      + prefectures.Oita \
                      + prefectures.Miyazaki \
                      + prefectures.Kagoshima \
                      + prefectures.Okinawa \
                      + prefectures.Others
    if @prefecture_total == prefectures.total
      return true
    end
    # totalを新しい値に更新
    prefectures.total = @prefecture_total
    return false
  end

  #すべての都道府県が0でないことを確認
  def check_not_all_zero(prefectures)
    # 北海道・東北から
    if prefectures.Hokkaido == 0 \
        && prefectures.Aomori == 0 \
        && prefectures.Iwate == 0 \
        && prefectures.Miyagi == 0 \
        && prefectures.Akita == 0 \
        && prefectures.Yamagata == 0 \
        && prefectures.Fukushima == 0 \
        && prefectures.Ibaraki == 0 \
        && prefectures.Tochigi == 0 \
        && prefectures.Gunma == 0 \
        && prefectures.Saitama == 0 \
        && prefectures.Chiba == 0 \
        && prefectures.Tokyo == 0 \
        && prefectures.Kanagawa == 0 \
        && prefectures.Niigata == 0 \
        && prefectures.Toyama == 0 \
        && prefectures.Ishikawa == 0 \
        && prefectures.Fukui == 0 \
        && prefectures.Yamanashi == 0 \
        && prefectures.Nagano == 0 \
        && prefectures.Gifu == 0 \
        && prefectures.Shizuoka == 0 \
        && prefectures.Aichi == 0 \
        && prefectures.Mie == 0 \
        && prefectures.Shiga == 0 \
        && prefectures.Kyoto == 0 \
        && prefectures.Osaka == 0 \
        && prefectures.Hyogo == 0 \
        && prefectures.Nara == 0 \
        && prefectures.Wakayama == 0 \
        && prefectures.Tottori == 0 \
        && prefectures.Shimane == 0 \
        && prefectures.Okayama == 0 \
        && prefectures.Hiroshima == 0 \
        && prefectures.Yamaguchi == 0 \
        && prefectures.Tokushima == 0 \
        && prefectures.Kagawa == 0 \
        && prefectures.Ehime == 0 \
        && prefectures.Kochi == 0 \
        && prefectures.Fukuoka == 0 \
        && prefectures.Saga == 0 \
        && prefectures.Nagasaki == 0 \
        && prefectures.Kumamoto == 0 \
        && prefectures.Oita == 0 \
        && prefectures.Miyazaki == 0 \
        && prefectures.Kagoshima == 0 \
        && prefectures.Okinawa == 0 \
        && prefectures.Others == 0 \
      #全て0ならfalse
      return false
    end

    #1つでも0以外があればtrue
    return true
  end

  private def event_prefecture_params
    attrs = [
      :event_id,
      :total,
      :Hokkaido,
      :Aomori,
      :Iwate,
      :Miyagi,
      :Akita,
      :Yamagata,
      :Fukushima,
      :Ibaraki,
      :Tochigi,
      :Gunma,
      :Saitama,
      :Chiba,
      :Tokyo,
      :Kanagawa,
      :Niigata,
      :Toyama,
      :Ishikawa,
      :Fukui,
      :Yamanashi,
      :Nagano,
      :Gifu,
      :Shizuoka,
      :Aichi,
      :Mie,
      :Shiga,
      :Kyoto,
      :Osaka,
      :Hyogo,
      :Nara,
      :Wakayama,
      :Tottori,
      :Shimane,
      :Okayama,
      :Hiroshima,
      :Yamaguchi,
      :Tokushima,
      :Kagawa,
      :Ehime,
      :Kochi,
      :Fukuoka,
      :Saga,
      :Nagasaki,
      :Kumamoto,
      :Oita,
      :Miyazaki,
      :Kagoshima,
      :Okinawa,
      :Others
    ]
    params.require(:event_prefecture).permit(attrs)
  end

end
