
class CsvsController < EventsController
  def index
    #登録されている値が正しいかチェックする
    check

    #CSVファイルリスト取得
    make_csv_arr
  end

  def check
    #CSVに書き込むデータ作成
    events_arr = make_arr()

    #画面表示用配列初期化
    @disp_arr = []

    #総人口、性別・年齢別人口総計、都道府県別人口総計が等しいか確認
    events_arr.each_with_index do |event, i|

      age_total = event["F1910"] \
                + event["F1920"] \
                + event["F1930"] \
                + event["F1940"] \
                + event["F1950"] \
                + event["F1960"] \
                + event["F1970"] \
                + event["F1980"] \
                + event["F1990"] \
                + event["F2000"] \
                + event["F2010"] \
                + event["M1910"] \
                + event["M1920"] \
                + event["M1930"] \
                + event["M1940"] \
                + event["M1950"] \
                + event["M1960"] \
                + event["M1970"] \
                + event["M1980"] \
                + event["M1990"] \
                + event["M2000"] \
                + event["M2010"]

        prefecture_total = event["1-Hokkaido"] \
                + event["2-Aomori"] \
                + event["3-Iwate"] \
                + event["4-Akita"] \
                + event["5-Miyagi"] \
                + event["6-Yamagata"] \
                + event["7-Fukushima"] \
                + event["8-Ibaraki"] \
                + event["9-Tochigi"] \
                + event["10-Gunma"] \
                + event["11-Saitama"] \
                + event["12-Chiba"] \
                + event["13-Tokyo"] \
                + event["14-Kanagawa"] \
                + event["15-Niigata"] \
                + event["16-Toyama"] \
                + event["17-Ishikawa"] \
                + event["18-Fukui"] \
                + event["19-Yamanashi"] \
                + event["20-Nagano"] \
                + event["21-Gifu"] \
                + event["22-Shizuoka"] \
                + event["23-Aichi"] \
                + event["24-Mie"] \
                + event["25-Shiga"] \
                + event["26-Kyoto"] \
                + event["27-Osaka"] \
                + event["28-Hyogo"] \
                + event["29-Nara"] \
                + event["30-Wakayama"] \
                + event["31-Tottori"] \
                + event["32-Shimane"] \
                + event["33-Okayama"] \
                + event["34-Hiroshima"] \
                + event["35-Yamaguchi"] \
                + event["36-Tokushima"] \
                + event["37-Kagawa"] \
                + event["38-Ehime"] \
                + event["39-Kochi"] \
                + event["40-Fukuoka"] \
                + event["41-Saga"] \
                + event["42-Nagasaki"] \
                + event["43-Kumamoto"] \
                + event["44-Oita"] \
                + event["45-Miyazaki"] \
                + event["46-Kagoshima"] \
                + event["47-Okinawa"] \
                + event["99-Others"]

      #沈没都道府県確認
      #使用変数宣言
      @half_pollution = '' #一部汚染
      @pollution = '' #全域汚染
      @half_snking = '' #沈没中都道府県
      @snking = '' #沈没都道府県
      @error_snking = '' #沈没なのに人口1以上
      #配列でループ
      event.each do |key, val|
        #地図の要素以外はスキップ
        if !key.include?("map_")
          next
        end

        #該当都道府県の人口取得
        wk_prefecture_key = key.sub('map_', '')
        wk_prefecture_val = event[wk_prefecture_key]

        #一部汚染、汚染で死者がいる場合、頭に「1_」「2_」がついているため、ここでは削除
        if val.to_s.include?("_")
          val = val.slice!(2, 1)
        end

        #一部汚染か確認
        if val == '5'
          if @half_pollution.present?
            #空でない場合、値の間にカンマを加える
            @half_pollution = @half_pollution + "," + convert_prefecture(wk_prefecture_key)
          else
            @half_pollution = @half_pollution + convert_prefecture(wk_prefecture_key)
          end
        end

        #全域汚染か確認
        if val == '6'
          if @pollution.present?
            #空でない場合、値の間にカンマを加える
            @pollution = @pollution + "," + convert_prefecture(wk_prefecture_key)
          else
            @pollution = @pollution + convert_prefecture(wk_prefecture_key)
          end
        end

        #沈没中か確認
        if val == '3'
          if @half_snking.present?
            #空でない場合、値の間にカンマを加える
            @half_snking = @half_snking + "," + convert_prefecture(wk_prefecture_key)
          else
            @half_snking = @half_snking + convert_prefecture(wk_prefecture_key)
          end
        end

        #沈没しているか確認
        if val == '4'
          if @snking.present?
            #空でない場合、値の間にカンマを加える
            @snking = @snking + "," + convert_prefecture(wk_prefecture_key)
          else
            @snking = @snking + convert_prefecture(wk_prefecture_key)
          end

          #沈没している場合、人口が0になっているか確認
          if 0 < wk_prefecture_val
            if @error_snking.present?
              #空でない場合、値の間にカンマを加える
              @error_snking = @error_snking + "," + convert_prefecture(wk_prefecture_key)
            else
              @error_snking = @error_snking + convert_prefecture(wk_prefecture_key)
            end
          end
        end
      end

      wk_hash = {
        "no"=>i + 1,
        "date"=>event["date"],
        "is_fake"=>event["is_fake"],
        "total"=>event["total"],
        "title"=>newStr = event["title"],
        "age_total"=>age_total,
        "age_diff"=>event["total"] - age_total,
        "prefecture_total"=>prefecture_total,
        "prefecture_diff"=>event["total"] - prefecture_total,
        "half_pollution"=>@half_pollution,
        "pollution"=>@pollution,
        "error"=>@error_snking,
        "half_snking"=>@half_snking,
        "snking"=>@snking
      }
      @disp_arr.push(wk_hash)
    end

    #51行以上の場合、保存ボタンを非表示
    @under50_flg = true
    if 50 < @disp_arr.length
      @under50_flg = false
    end

    return @disp_arr
  end

  #csv出力
  def make_csv
    require 'date'
    if params[:file_name] == ""
      fine_name = "FILE"
    else
      fine_name = params[:file_name]
    end

    #ファイル名が16文字以上の場合、16文字目以降を削除する
    if 16 <= fine_name.length
      fine_name = fine_name.slice(0,15)
    end

    file_name = Date.today.to_s + '_' + fine_name
    dir_name = meke_dir_name()
    path = dir_name + file_name + '.csv'

    #CSVに書き込むデータ作成
    wk_arr = make_arr()

    #CSVに書き込むデータから、年間人口増減を削除
    wk_arr = wk_arr.select { |record| record['type'] == 0 }

    #CSV書き込み
    require "csv"
    CSV.open(path,'w:utf-8') do |target|
      #データ部
      wk_arr.each_with_index do |hash, i|
        #年間推移は除外
        if hash["event_type"]
          next
        end

        #最初のループの場合ヘッダ配列を生成
        if i == 0
          wk_arr_head = []
          hash.each do |key, val|
            wk_arr_head.push(key)
          end
          #書き込み
          target << wk_arr_head
        end

        #データ生成
        wk_arr_data = []
        hash.each do |key, val|
          wk_arr_data.push(val)
        end
        #書き込み
        target << wk_arr_data
      end
    end

    redirect_to action: 'index'
  end

  def make_arr()
    #管理者かどうか
    @admin_flg = session[:member_admin]

    if @admin_flg
      #管理者の場合
      #セッションに格納してあるフィルターID取得
      if session[:filter_member_id] == nil || session[:filter_member_id] == ''
        #全出来事を取得
        wk_events = Event.where(is_active: true).order(:date)
      else
        #該当メンバのデータのみ取得
        wk_events = Event.where("is_active = ? AND member_id = ?", true, session[:filter_member_id]).order(:date)
      end

    else
      #一般メンバーの場合、自分の出来事だけ取得
      wk_events = Event.where("is_active = ? AND member_id = ?", true, session[:member_id]).order(:date)
    end

    #イベント絞り込み
    @events = [];
    wk_events.each do |event|
      if available_event(event, false)
        @events.push(event)
      end
    end

    #CSV出力用ハッシュ作成
    #リストの先頭(2011-01-01のレコード)作成
    arr = make_hash_first(@events[0])

    #イベント二行以降作成
    arr = meka_arr_data(@events, @arr)

    return arr
  end

  #csvディレクトリ名作成
  def meke_dir_name()
    ret = session[:member_id].to_s + "_member/"
    #相対パス指定
    return (Rails.root.join('app', 'csv', ret)).to_s
  end

  #2011年1月1日時点でのデータ作成
  def make_hash_first(event)
    #ConstTBLに登録されている総人口取得
    @total_population = Const.find_by(key: "TOTAL_POPULATION")

    # ageTBLに登録されている値取得
    @age_and_genders_bfore = Age.order("id").first

    # prefecturTBLに登録されている値取得
    @prefectures_bfore = Prefecture.order("id").first

    hash = {
      "no"=>0,
      "date"=>event.date,
      "type"=>event.event_type,
      "total"=>@total_population.value,
      "F1910"=>@age_and_genders_bfore.F1910,
      "F1920"=>@age_and_genders_bfore.F1920,
      "F1930"=>@age_and_genders_bfore.F1930,
      "F1940"=>@age_and_genders_bfore.F1940,
      "F1950"=>@age_and_genders_bfore.F1950,
      "F1960"=>@age_and_genders_bfore.F1960,
      "F1970"=>@age_and_genders_bfore.F1970,
      "F1980"=>@age_and_genders_bfore.F1980,
      "F1990"=>@age_and_genders_bfore.F1990,
      "F2000"=>@age_and_genders_bfore.F2000,
      "F2010"=>@age_and_genders_bfore.F2010,
      "M1910"=>@age_and_genders_bfore.M1910,
      "M1920"=>@age_and_genders_bfore.M1920,
      "M1930"=>@age_and_genders_bfore.M1930,
      "M1940"=>@age_and_genders_bfore.M1940,
      "M1950"=>@age_and_genders_bfore.M1950,
      "M1960"=>@age_and_genders_bfore.M1960,
      "M1970"=>@age_and_genders_bfore.M1970,
      "M1980"=>@age_and_genders_bfore.M1980,
      "M1990"=>@age_and_genders_bfore.M1990,
      "M2000"=>@age_and_genders_bfore.M2000,
      "M2010"=>@age_and_genders_bfore.M2010,
      "1-Hokkaido"=>@prefectures_bfore.Hokkaido,
      "2-Aomori"=>@prefectures_bfore.Aomori,
      "3-Iwate"=>@prefectures_bfore.Iwate,
      "4-Akita"=>@prefectures_bfore.Akita,
      "5-Miyagi"=>@prefectures_bfore.Miyagi,
      "6-Yamagata"=>@prefectures_bfore.Yamagata,
      "7-Fukushima"=>@prefectures_bfore.Fukushima,
      "8-Ibaraki"=>@prefectures_bfore.Ibaraki,
      "9-Tochigi"=>@prefectures_bfore.Tochigi,
      "10-Gunma"=>@prefectures_bfore.Gunma,
      "11-Saitama"=>@prefectures_bfore.Saitama,
      "12-Chiba"=>@prefectures_bfore.Chiba,
      "13-Tokyo"=>@prefectures_bfore.Tokyo,
      "14-Kanagawa"=>@prefectures_bfore.Kanagawa,
      "15-Niigata"=>@prefectures_bfore.Niigata,
      "16-Toyama"=>@prefectures_bfore.Toyama,
      "17-Ishikawa"=>@prefectures_bfore.Ishikawa,
      "18-Fukui"=>@prefectures_bfore.Fukui,
      "19-Yamanashi"=>@prefectures_bfore.Yamanashi,
      "20-Nagano"=>@prefectures_bfore.Nagano,
      "21-Gifu"=>@prefectures_bfore.Gifu,
      "22-Shizuoka"=>@prefectures_bfore.Shizuoka,
      "23-Aichi"=>@prefectures_bfore.Aichi,
      "24-Mie"=>@prefectures_bfore.Mie,
      "25-Shiga"=>@prefectures_bfore.Shiga,
      "26-Kyoto"=>@prefectures_bfore.Kyoto,
      "27-Osaka"=>@prefectures_bfore.Osaka,
      "28-Hyogo"=>@prefectures_bfore.Hyogo,
      "29-Nara"=>@prefectures_bfore.Nara,
      "30-Wakayama"=>@prefectures_bfore.Wakayama,
      "31-Tottori"=>@prefectures_bfore.Tottori,
      "32-Shimane"=>@prefectures_bfore.Shimane,
      "33-Okayama"=>@prefectures_bfore.Okayama,
      "34-Hiroshima"=>@prefectures_bfore.Hiroshima,
      "35-Yamaguchi"=>@prefectures_bfore.Yamaguchi,
      "36-Tokushima"=>@prefectures_bfore.Tokushima,
      "37-Kagawa"=>@prefectures_bfore.Kagawa,
      "38-Ehime"=>@prefectures_bfore.Ehime,
      "39-Kochi"=>@prefectures_bfore.Kochi,
      "40-Fukuoka"=>@prefectures_bfore.Fukuoka,
      "41-Saga"=>@prefectures_bfore.Saga,
      "42-Nagasaki"=>@prefectures_bfore.Nagasaki,
      "43-Kumamoto"=>@prefectures_bfore.Kumamoto,
      "44-Oita"=>@prefectures_bfore.Oita,
      "45-Miyazaki"=>@prefectures_bfore.Miyazaki,
      "46-Kagoshima"=>@prefectures_bfore.Kagoshima,
      "47-Okinawa"=>@prefectures_bfore.Okinawa,
      "99-Others"=>@prefectures_bfore.Others,
      "map_1-Hokkaido"=>0,
      "map_2-Aomori"=>0,
      "map_3-Iwate"=>0,
      "map_4-Akita"=>0,
      "map_5-Miyagi"=>0,
      "map_6-Yamagata"=>0,
      "map_7-Fukushima"=>0,
      "map_8-Ibaraki"=>0,
      "map_9-Tochigi"=>0,
      "map_10-Gunma"=>0,
      "map_11-Saitama"=>0,
      "map_12-Chiba"=>0,
      "map_13-Tokyo"=>0,
      "map_14-Kanagawa"=>0,
      "map_15-Niigata"=>0,
      "map_16-Toyama"=>0,
      "map_17-Ishikawa"=>0,
      "map_18-Fukui"=>0,
      "map_19-Yamanashi"=>0,
      "map_20-Nagano"=>0,
      "map_21-Gifu"=>0,
      "map_22-Shizuoka"=>0,
      "map_23-Aichi"=>0,
      "map_24-Mie"=>0,
      "map_25-Shiga"=>0,
      "map_26-Kyoto"=>0,
      "map_27-Osaka"=>0,
      "map_28-Hyogo"=>0,
      "map_29-Nara"=>0,
      "map_30-Wakayama"=>0,
      "map_31-Tottori"=>0,
      "map_32-Shimane"=>0,
      "map_33-Okayama"=>0,
      "map_34-Hiroshima"=>0,
      "map_35-Yamaguchi"=>0,
      "map_36-Tokushima"=>0,
      "map_37-Kagawa"=>0,
      "map_38-Ehime"=>0,
      "map_39-Kochi"=>0,
      "map_40-Fukuoka"=>0,
      "map_41-Saga"=>0,
      "map_42-Nagasaki"=>0,
      "map_43-Kumamoto"=>0,
      "map_44-Oita"=>0,
      "map_45-Miyazaki"=>0,
      "map_46-Kagoshima"=>0,
      "map_47-Okinawa"=>0,
      "map_99-Others"=>0,
      "title"=>event.title,
      "detail"=>event.detail,
      "is_fake"=>event.is_fake,
      "event_id"=>event.id,
    }
    #返却配列初期化
    @arr = []
    #配列にハッシュを格納
    @arr.push(hash)
    return @arr
  end


  def meka_arr_data(events, arr)
    events.each_with_index do |event, i|
      #最初のレコードは2011-01-01のため処理をしない
      if i == 0
        next
      end

      #該当イベントの一つ前のイベント取得
      @before = arr[arr.size - 1]
      #基本的な事項をリスト格納
      @hash_basic = {
        "no"=>i,
        "date"=>event.date,
        "type"=>event.event_type,
        "total"=>@before["total"] + event.population_change,
      }

      #性別・年齢別人口増減取得
      @event_age = EventAge.find_by(event_id: event.id)
      if @event_age.present?
        #人口増減が存在する場合
        #人口増減リスト
        @hash_age = {
          "F1910"=>@before["F1910"] + @event_age.F1910,
          "F1920"=>@before["F1920"] + @event_age.F1920,
          "F1930"=>@before["F1930"] + @event_age.F1930,
          "F1940"=>@before["F1940"] + @event_age.F1940,
          "F1950"=>@before["F1950"] + @event_age.F1950,
          "F1960"=>@before["F1960"] + @event_age.F1960,
          "F1970"=>@before["F1970"] + @event_age.F1970,
          "F1980"=>@before["F1980"] + @event_age.F1980,
          "F1990"=>@before["F1990"] + @event_age.F1990,
          "F2000"=>@before["F2000"] + @event_age.F2000,
          "F2010"=>@before["F2010"] + @event_age.F2010,
          "M1910"=>@before["M1910"] + @event_age.M1910,
          "M1920"=>@before["M1920"] + @event_age.M1920,
          "M1930"=>@before["M1930"] + @event_age.M1930,
          "M1940"=>@before["M1940"] + @event_age.M1940,
          "M1950"=>@before["M1950"] + @event_age.M1950,
          "M1960"=>@before["M1960"] + @event_age.M1960,
          "M1970"=>@before["M1970"] + @event_age.M1970,
          "M1980"=>@before["M1980"] + @event_age.M1980,
          "M1990"=>@before["M1990"] + @event_age.M1990,
          "M2000"=>@before["M2000"] + @event_age.M2000,
          "M2010"=>@before["M2010"] + @event_age.M2010
        }
        #マイナスの値が出た場合、0に変換する
        @hash_age.each do |key, val|
          if val < 0
            @hash_age[key] = 0
          end
        end
      else
        #人口増減が存在しない場合
        @hash_age = {
          "F1910"=>@before["F1910"],
          "F1920"=>@before["F1920"],
          "F1930"=>@before["F1930"],
          "F1940"=>@before["F1940"],
          "F1950"=>@before["F1950"],
          "F1960"=>@before["F1960"],
          "F1970"=>@before["F1970"],
          "F1980"=>@before["F1980"],
          "F1990"=>@before["F1990"],
          "F2000"=>@before["F2000"],
          "F2010"=>@before["F2010"],
          "M1910"=>@before["M1910"],
          "M1920"=>@before["M1920"],
          "M1930"=>@before["M1930"],
          "M1940"=>@before["M1940"],
          "M1950"=>@before["M1950"],
          "M1960"=>@before["M1960"],
          "M1970"=>@before["M1970"],
          "M1980"=>@before["M1980"],
          "M1990"=>@before["M1990"],
          "M2000"=>@before["M2000"],
          "M2010"=>@before["M2010"]
        }
      end

      #都道府県別人口増減取得
      @event_prefecture = EventPrefecture.find_by(event_id: event.id)
      if @event_prefecture.present?
        #人口増減が存在する場合
        @hash_prefecture = {
          "1-Hokkaido"=>@before["1-Hokkaido"]+ @event_prefecture.Hokkaido,
          "2-Aomori"=>@before["2-Aomori"]+ @event_prefecture.Aomori,
          "3-Iwate"=>@before["3-Iwate"]+ @event_prefecture.Iwate,
          "4-Akita"=>@before["4-Akita"]+ @event_prefecture.Akita,
          "5-Miyagi"=>@before["5-Miyagi"]+ @event_prefecture.Miyagi,
          "6-Yamagata"=>@before["6-Yamagata"]+ @event_prefecture.Yamagata,
          "7-Fukushima"=>@before["7-Fukushima"]+ @event_prefecture.Fukushima,
          "8-Ibaraki"=>@before["8-Ibaraki"]+ @event_prefecture.Ibaraki,
          "9-Tochigi"=>@before["9-Tochigi"]+ @event_prefecture.Tochigi,
          "10-Gunma"=>@before["10-Gunma"]+ @event_prefecture.Gunma,
          "11-Saitama"=>@before["11-Saitama"]+ @event_prefecture.Saitama,
          "12-Chiba"=>@before["12-Chiba"]+ @event_prefecture.Chiba,
          "13-Tokyo"=>@before["13-Tokyo"]+ @event_prefecture.Tokyo,
          "14-Kanagawa"=>@before["14-Kanagawa"]+ @event_prefecture.Kanagawa,
          "15-Niigata"=>@before["15-Niigata"]+ @event_prefecture.Niigata,
          "16-Toyama"=>@before["16-Toyama"]+ @event_prefecture.Toyama,
          "17-Ishikawa"=>@before["17-Ishikawa"]+ @event_prefecture.Ishikawa,
          "18-Fukui"=>@before["18-Fukui"]+ @event_prefecture.Fukui,
          "19-Yamanashi"=>@before["19-Yamanashi"]+ @event_prefecture.Yamanashi,
          "20-Nagano"=>@before["20-Nagano"]+ @event_prefecture.Nagano,
          "21-Gifu"=>@before["21-Gifu"]+ @event_prefecture.Gifu,
          "22-Shizuoka"=>@before["22-Shizuoka"]+ @event_prefecture.Shizuoka,
          "23-Aichi"=>@before["23-Aichi"]+ @event_prefecture.Aichi,
          "24-Mie"=>@before["24-Mie"]+ @event_prefecture.Mie,
          "25-Shiga"=>@before["25-Shiga"]+ @event_prefecture.Shiga,
          "26-Kyoto"=>@before["26-Kyoto"]+ @event_prefecture.Kyoto,
          "27-Osaka"=>@before["27-Osaka"]+ @event_prefecture.Osaka,
          "28-Hyogo"=>@before["28-Hyogo"]+ @event_prefecture.Hyogo,
          "29-Nara"=>@before["29-Nara"]+ @event_prefecture.Nara,
          "30-Wakayama"=>@before["30-Wakayama"]+ @event_prefecture.Wakayama,
          "31-Tottori"=>@before["31-Tottori"]+ @event_prefecture.Tottori,
          "32-Shimane"=>@before["32-Shimane"]+ @event_prefecture.Shimane,
          "33-Okayama"=>@before["33-Okayama"]+ @event_prefecture.Okayama,
          "34-Hiroshima"=>@before["34-Hiroshima"]+ @event_prefecture.Hiroshima,
          "35-Yamaguchi"=>@before["35-Yamaguchi"]+ @event_prefecture.Yamaguchi,
          "36-Tokushima"=>@before["36-Tokushima"]+ @event_prefecture.Tokushima,
          "37-Kagawa"=>@before["37-Kagawa"]+ @event_prefecture.Kagawa,
          "38-Ehime"=>@before["38-Ehime"]+ @event_prefecture.Ehime,
          "39-Kochi"=>@before["39-Kochi"]+ @event_prefecture.Kochi,
          "40-Fukuoka"=>@before["40-Fukuoka"]+ @event_prefecture.Fukuoka,
          "41-Saga"=>@before["41-Saga"]+ @event_prefecture.Saga,
          "42-Nagasaki"=>@before["42-Nagasaki"]+ @event_prefecture.Nagasaki,
          "43-Kumamoto"=>@before["43-Kumamoto"]+ @event_prefecture.Kumamoto,
          "44-Oita"=>@before["44-Oita"]+ @event_prefecture.Oita,
          "45-Miyazaki"=>@before["45-Miyazaki"]+ @event_prefecture.Miyazaki,
          "46-Kagoshima"=>@before["46-Kagoshima"]+ @event_prefecture.Kagoshima,
          "47-Okinawa"=>@before["47-Okinawa"]+ @event_prefecture.Okinawa,
          "99-Others"=>@before["99-Others"]+ @event_prefecture.Others
        }
        #マイナスの値が出た場合、0に変換する
        @hash_prefecture.each do |key, val|
          if val < 0
            @hash_prefecture[key] = 0
          end
        end
      else
        #人口増減が存在しない場合
        @hash_prefecture = {
          "1-Hokkaido"=>@before["1-Hokkaido"],
          "2-Aomori"=>@before["2-Aomori"],
          "3-Iwate"=>@before["3-Iwate"],
          "4-Akita"=>@before["4-Akita"],
          "5-Miyagi"=>@before["5-Miyagi"],
          "6-Yamagata"=>@before["6-Yamagata"],
          "7-Fukushima"=>@before["7-Fukushima"],
          "8-Ibaraki"=>@before["8-Ibaraki"],
          "9-Tochigi"=>@before["9-Tochigi"],
          "10-Gunma"=>@before["10-Gunma"],
          "11-Saitama"=>@before["11-Saitama"],
          "12-Chiba"=>@before["12-Chiba"],
          "13-Tokyo"=>@before["13-Tokyo"],
          "14-Kanagawa"=>@before["14-Kanagawa"],
          "15-Niigata"=>@before["15-Niigata"],
          "16-Toyama"=>@before["16-Toyama"],
          "17-Ishikawa"=>@before["17-Ishikawa"],
          "18-Fukui"=>@before["18-Fukui"],
          "19-Yamanashi"=>@before["19-Yamanashi"],
          "20-Nagano"=>@before["20-Nagano"],
          "21-Gifu"=>@before["21-Gifu"],
          "22-Shizuoka"=>@before["22-Shizuoka"],
          "23-Aichi"=>@before["23-Aichi"],
          "24-Mie"=>@before["24-Mie"],
          "25-Shiga"=>@before["25-Shiga"],
          "26-Kyoto"=>@before["26-Kyoto"],
          "27-Osaka"=>@before["27-Osaka"],
          "28-Hyogo"=>@before["28-Hyogo"],
          "29-Nara"=>@before["29-Nara"],
          "30-Wakayama"=>@before["30-Wakayama"],
          "31-Tottori"=>@before["31-Tottori"],
          "32-Shimane"=>@before["32-Shimane"],
          "33-Okayama"=>@before["33-Okayama"],
          "34-Hiroshima"=>@before["34-Hiroshima"],
          "35-Yamaguchi"=>@before["35-Yamaguchi"],
          "36-Tokushima"=>@before["36-Tokushima"],
          "37-Kagawa"=>@before["37-Kagawa"],
          "38-Ehime"=>@before["38-Ehime"],
          "39-Kochi"=>@before["39-Kochi"],
          "40-Fukuoka"=>@before["40-Fukuoka"],
          "41-Saga"=>@before["41-Saga"],
          "42-Nagasaki"=>@before["42-Nagasaki"],
          "43-Kumamoto"=>@before["43-Kumamoto"],
          "44-Oita"=>@before["44-Oita"],
          "45-Miyazaki"=>@before["45-Miyazaki"],
          "46-Kagoshima"=>@before["46-Kagoshima"],
          "47-Okinawa"=>@before["47-Okinawa"],
          "99-Others"=>@before["99-Others"]
        }
      end

      #都道府県色分け
      #ひとまず一つ前の出来事の色を踏襲する
      @hash_map = {
        "map_1-Hokkaido"=>remove_under_score(@before["map_1-Hokkaido"]),
        "map_2-Aomori"=>remove_under_score(@before["map_2-Aomori"]),
        "map_3-Iwate"=>remove_under_score(@before["map_3-Iwate"]),
        "map_4-Akita"=>remove_under_score(@before["map_4-Akita"]),
        "map_5-Miyagi"=>remove_under_score(@before["map_5-Miyagi"]),
        "map_6-Yamagata"=>remove_under_score(@before["map_6-Yamagata"]),
        "map_7-Fukushima"=>remove_under_score(@before["map_7-Fukushima"]),
        "map_8-Ibaraki"=>remove_under_score(@before["map_8-Ibaraki"]),
        "map_9-Tochigi"=>remove_under_score(@before["map_9-Tochigi"]),
        "map_10-Gunma"=>remove_under_score(@before["map_10-Gunma"]),
        "map_11-Saitama"=>remove_under_score(@before["map_11-Saitama"]),
        "map_12-Chiba"=>remove_under_score(@before["map_12-Chiba"]),
        "map_13-Tokyo"=>remove_under_score(@before["map_13-Tokyo"]),
        "map_14-Kanagawa"=>remove_under_score(@before["map_14-Kanagawa"]),
        "map_15-Niigata"=>remove_under_score(@before["map_15-Niigata"]),
        "map_16-Toyama"=>remove_under_score(@before["map_16-Toyama"]),
        "map_17-Ishikawa"=>remove_under_score(@before["map_17-Ishikawa"]),
        "map_18-Fukui"=>remove_under_score(@before["map_18-Fukui"]),
        "map_19-Yamanashi"=>remove_under_score(@before["map_19-Yamanashi"]),
        "map_20-Nagano"=>remove_under_score(@before["map_20-Nagano"]),
        "map_21-Gifu"=>remove_under_score(@before["map_21-Gifu"]),
        "map_22-Shizuoka"=>remove_under_score(@before["map_22-Shizuoka"]),
        "map_23-Aichi"=>remove_under_score(@before["map_23-Aichi"]),
        "map_24-Mie"=>remove_under_score(@before["map_24-Mie"]),
        "map_25-Shiga"=>remove_under_score(@before["map_25-Shiga"]),
        "map_26-Kyoto"=>remove_under_score(@before["map_26-Kyoto"]),
        "map_27-Osaka"=>remove_under_score(@before["map_27-Osaka"]),
        "map_28-Hyogo"=>remove_under_score(@before["map_28-Hyogo"]),
        "map_29-Nara"=>remove_under_score(@before["map_29-Nara"]),
        "map_30-Wakayama"=>remove_under_score(@before["map_30-Wakayama"]),
        "map_31-Tottori"=>remove_under_score(@before["map_31-Tottori"]),
        "map_32-Shimane"=>remove_under_score(@before["map_32-Shimane"]),
        "map_33-Okayama"=>remove_under_score(@before["map_33-Okayama"]),
        "map_34-Hiroshima"=>remove_under_score(@before["map_34-Hiroshima"]),
        "map_35-Yamaguchi"=>remove_under_score(@before["map_35-Yamaguchi"]),
        "map_36-Tokushima"=>remove_under_score(@before["map_36-Tokushima"]),
        "map_37-Kagawa"=>remove_under_score(@before["map_37-Kagawa"]),
        "map_38-Ehime"=>remove_under_score(@before["map_38-Ehime"]),
        "map_39-Kochi"=>remove_under_score(@before["map_39-Kochi"]),
        "map_40-Fukuoka"=>remove_under_score(@before["map_40-Fukuoka"]),
        "map_41-Saga"=>remove_under_score(@before["map_41-Saga"]),
        "map_42-Nagasaki"=>remove_under_score(@before["map_42-Nagasaki"]),
        "map_43-Kumamoto"=>remove_under_score(@before["map_43-Kumamoto"]),
        "map_44-Oita"=>remove_under_score(@before["map_44-Oita"]),
        "map_45-Miyazaki"=>remove_under_score(@before["map_45-Miyazaki"]),
        "map_46-Kagoshima"=>remove_under_score(@before["map_46-Kagoshima"]),
        "map_47-Okinawa"=>remove_under_score(@before["map_47-Okinawa"]),
        "map_99-Others"=>remove_under_score(@before["map_99-Others"])
      }

      #値が1か2の場合、ひとまず0にする
      @hash_map.each do |key, val|
        if val == '1' || val == '2'
          @hash_map[key] = '0'
        end
      end

      #年間人口移動、犠牲者0の場合、以外犠牲者を色付け
      if event.event_type == 0 || event.population_change == 0
        if event.population_change <= -10
          @damage_prefecture_hash = damage_list(@event_prefecture)
          #都道府県人口増減で-10～-49だった場合
          @damage_prefecture_hash.each do |key, val|
            if -50 < val && val <= -10
              @wk_key = key
              if @hash_map[@wk_key] == '5' || @hash_map[@wk_key] == '6' || @hash_map[@wk_key] == '3'
                # 一部沈没、汚染、一部汚染の場合、間にアンスコを挟む
                @hash_map[@wk_key] = '1_' + @hash_map[@wk_key]
              elsif @hash_map[@wk_key] == '4'
                # 完全沈没の場合、死者数の値は使わない
                @hash_map[@wk_key] == '4'
              else
                @hash_map[@wk_key] = '1'
              end
            end
          end
          #都道府県人口増減で-50～だった場合
          @damage_prefecture_hash.each do |key, val|
            if val <= -50
              @wk_key = key
              if @hash_map[@wk_key] == '5' || @hash_map[@wk_key] == '6' || @hash_map[@wk_key] == '3'
                # 一部沈没、汚染、一部汚染の場合、間にアンスコを挟む
                @hash_map[@wk_key] = '2_' + @hash_map[@wk_key]
              elsif @hash_map[@wk_key] == '4'
                # 完全沈没の場合、死者数の値は使わない
                @hash_map[@wk_key] == '4'
              else
                @hash_map[@wk_key] = '2'
              end
            end
          end
        end
      end

      #ここから大変------------------------------------
      #汚染・沈没ロジック
      #ひとまず全4パターン
      # 1:一部汚染、2:全域汚染、3:一部沈没、4:全域沈没（番号は大きいほど優先）

      #一部汚染の場合
      @half_pollution_commma = event.half_pollution
      if @half_pollution_commma.present?
        #カンマ区切りを配列化
        @pollution_arr = @half_pollution_commma.split(",")

        #配列でループ
        @pollution_arr.each do |key|
          #完全に沈没の色にする
          @wk_key = "map_" + key
          @hash_map[@wk_key] = '5'
        end
      end

      #全域汚染の場合
      @pollution_commma = event.pollution
      if @pollution_commma.present?
        #カンマ区切りを配列化
        @pollution_arr = @pollution_commma.split(",")

        #配列でループ
        @pollution_arr.each do |key|
          #全域汚染の色にする
          @wk_key = "map_" + key
          @hash_map[@wk_key] = '6'
        end
      end

      #50%沈没の場合
      #50%沈没都道府県を取得
      @half_sinking_commma = event.half_sinking
      if @half_sinking_commma.present?
        #カンマ区切りを配列化
        @sinking_arr = @half_sinking_commma.split(",")

        #配列でループ
        @sinking_arr.each do |key|
          #完全に沈没の色にする
          @wk_key = "map_" + key
          @hash_map[@wk_key] = '3'
        end
      end

      #沈没都道府県を取得
      @sinking_commma = event.sinking
      if @sinking_commma.present?
        #カンマ区切りを配列化
        @sinking_arr = @sinking_commma.split(",")

        #配列でループ
        @sinking_arr.each do |key|
          #完全に沈没の色にする
          @wk_key = "map_" + key
          @hash_map[@wk_key] = '4'
        end
      end

      @hash_other = {
        "title"=>event.title,
        "detail"=>event.detail,
        "is_fake"=>event.is_fake,
        "event_id"=>event.id
      }

      #リスト結合
      @hash = @hash_basic.merge!(@hash_age).merge!(@hash_prefecture).merge!(@hash_map).merge!(@hash_other)

      #返却配列初期化
      #配列にハッシュを格納
      arr.push(@hash)
    end
    return arr
  end

  def damage_list(event_prefecture)
    damage_prefecture_hash = {
      "map_1-Hokkaido"=>event_prefecture.Hokkaido,
      "map_2-Aomori"=>event_prefecture.Aomori,
      "map_3-Iwate"=>event_prefecture.Iwate,
      "map_4-Akita"=>event_prefecture.Akita,
      "map_5-Miyagi"=>event_prefecture.Miyagi,
      "map_6-Yamagata"=>event_prefecture.Yamagata,
      "map_7-Fukushima"=>event_prefecture.Fukushima,
      "map_8-Ibaraki"=>event_prefecture.Ibaraki,
      "map_9-Tochigi"=>event_prefecture.Tochigi,
      "map_10-Gunma"=>event_prefecture.Gunma,
      "map_11-Saitama"=>event_prefecture.Saitama,
      "map_12-Chiba"=>event_prefecture.Chiba,
      "map_13-Tokyo"=>event_prefecture.Tokyo,
      "map_14-Kanagawa"=>event_prefecture.Kanagawa,
      "map_15-Niigata"=>event_prefecture.Niigata,
      "map_16-Toyama"=>event_prefecture.Toyama,
      "map_17-Ishikawa"=>event_prefecture.Ishikawa,
      "map_18-Fukui"=>event_prefecture.Fukui,
      "map_19-Yamanashi"=>event_prefecture.Yamanashi,
      "map_20-Nagano"=>event_prefecture.Nagano,
      "map_21-Gifu"=>event_prefecture.Gifu,
      "map_22-Shizuoka"=>event_prefecture.Shizuoka,
      "map_23-Aichi"=>event_prefecture.Aichi,
      "map_24-Mie"=>event_prefecture.Mie,
      "map_25-Shiga"=>event_prefecture.Shiga,
      "map_26-Kyoto"=>event_prefecture.Kyoto,
      "map_27-Osaka"=>event_prefecture.Osaka,
      "map_28-Hyogo"=>event_prefecture.Hyogo,
      "map_29-Nara"=>event_prefecture.Nara,
      "map_30-Wakayama"=>event_prefecture.Wakayama,
      "map_31-Tottori"=>event_prefecture.Tottori,
      "map_32-Shimane"=>event_prefecture.Shimane,
      "map_33-Okayama"=>event_prefecture.Okayama,
      "map_34-Hiroshima"=>event_prefecture.Hiroshima,
      "map_35-Yamaguchi"=>event_prefecture.Yamaguchi,
      "map_36-Tokushima"=>event_prefecture.Tokushima,
      "map_37-Kagawa"=>event_prefecture.Kagawa,
      "map_38-Ehime"=>event_prefecture.Ehime,
      "map_39-Kochi"=>event_prefecture.Kochi,
      "map_40-Fukuoka"=>event_prefecture.Fukuoka,
      "map_41-Saga"=>event_prefecture.Saga,
      "map_42-Nagasaki"=>event_prefecture.Nagasaki,
      "map_43-Kumamoto"=>event_prefecture.Kumamoto,
      "map_44-Oita"=>event_prefecture.Oita,
      "map_45-Miyazaki"=>event_prefecture.Miyazaki,
      "map_46-Kagoshima"=>event_prefecture.Kagoshima,
      "map_47-Okinawa"=>event_prefecture.Okinawa,
      "map_99-Others"=>event_prefecture.Others
    }
    return damage_prefecture_hash
  end

  #CSVのファイル一覧取得
  def make_csv_arr
    #csvフォルダ内のcsvを取得
    @csv_arr = [];
    @csv_arr.push("")
    dir_name = meke_dir_name()
    Dir.glob(dir_name + '*') do |item|
      next if item == '.' or item == '..'
      wk_item = item.sub(dir_name , '')
      #target.csvでなければ、画面に表示するcsvファイル名を配列に格納
      if wk_item != "target.csv" && wk_item != "target.txt"
        #画面表示用に.csvを削除する
        wk_display_name = cut_file_name_csv(wk_item)
        wk_item_arr = [wk_display_name, wk_item]
        @csv_arr.push(wk_item_arr)
      end
    end

    #デフォルトデータを末尾に設定
    wk_item_arr = ["サンプル", "default.csv"]
    @csv_arr.push(wk_item_arr)

    #現在の画面表示CSV名を取得
    @target_csv = "設定されていません"
    @default_data_flg = false
    text_file_name = meke_dir_name() + "target.txt"
    file = File.open(text_file_name,"r")
    file.each do |text|

      #デフォルト作品状態か否かを確認
      if text.include?("設定されていませんxxx")
        @default_data_flg = true
      end

      #画面表示用に.csvを削除する
      wk_display_name = cut_file_name_csv(text)
      @target_csv = wk_display_name
    end
  end

  #拡張子.csv削除
  def cut_file_name_csv(file_name)

    #画面表示用に.csvを削除する
    wk_display_name = file_name.chop
    wk_display_name = wk_display_name.chop
    wk_display_name = wk_display_name.chop
    wk_display_name = wk_display_name.chop
    return wk_display_name
  end

  #画面表示CSV設定
  def set_target_csv
    #選択されたファイル名
    targe_file_name = meke_dir_name() + params[:csv]
    #画面表示ファイル名
    display_file_name = meke_dir_name() + "target.csv"
    #該当ファイルをコピー
    FileUtils.cp(targe_file_name, display_file_name)

    #target.txtに該当ファイル名を書き込み
    #画面表示ファイル名
    text_file_name = meke_dir_name() + "target.txt"
    File.open(text_file_name, mode = "w"){|f|
      f.write(params[:csv])  # ファイルに書き込む
    }

    #デフォルト上書きにチェックがあった場合
    @admin_flg = session[:member_admin]
    if @admin_flg
      if params[:update_default]
        #画面表示ファイル名
        dafult_file_name = (Rails.root.join('app', 'csv', "default.csv")).to_s
        #該当ファイルをコピー
        FileUtils.cp(targe_file_name, dafult_file_name)
      end
    end

    redirect_to action: 'index'
  end

  #csvファイル削除
  def delete_target_csv
    # ファイルを削除する
    dir_name = meke_dir_name()
    FileUtils.rm(dir_name + params[:csv])
    redirect_to action: 'index'
  end

  #色変更
  def color_change

    #画面色がDBに存在するか確認
    record = Const.find_by(key: "DISPLAY_COLOR")
    if !record.present?
      record = Const.new()
      record.value = 0
      record.key = "DISPLAY_COLOR"
      record.value_str = "white"
      record.save
    end
    #現在の画面色再取得
    color_db = Const.find_by(key: "DISPLAY_COLOR")
    #画面で選択された画面色取得
    color_prm = params[:display_color]

    #画面で選択された色とDBに登録されている色が同じの場合、以降の処理を実施しない
    if color_db.value_str == color_prm
      redirect_to action: 'index'
      return
    else
      color_db.value_str = color_prm
      color_db.save
    end

    # 白にする場合
    # 背景:#ffffff、文字色:#000000、ブロック:#e6ecfe、ブロック枠:#beccea、日付文字:#c0c0c0
    # 黒にする場合
    # 背景:#061a2b、文字色:#fffafa、ブロック:#242a3c、ブロック枠:#e6ecfe、日付文字:#f0f8ff

    # 読み取り専用でログファイルを開く
    file = File.open("app/assets/stylesheets/main.css" , "r")

    # 保存用バッファ
    buffer = file.read()

    #色変換
    if color_prm == "white"
      buffer.gsub!("#f0f8ff","#696969")#日付文字
      buffer.gsub!("061a2b","ffffff")#背景色
      buffer.gsub!("fffafa","000000")#文字色
      buffer.gsub!("242a3c","e6ecfe")#ブロック
      buffer.gsub!("474f62","beccea")#ブロック枠
      buffer.gsub!("808080","e6e6fa")#非活性の年

    else
      buffer.gsub!("#696969","#f0f8ff")#日付文字
      buffer.gsub!("ffffff","061a2b")#背景色
      buffer.gsub!("000000","fffafa")#文字色
      buffer.gsub!("e6ecfe","242a3c")#ブロック
      buffer.gsub!("beccea","474f62")#ブロック枠
      buffer.gsub!("e6e6fa","808080")#非活性の年

    end

    # ログファイルを書き込みモードで開き直す
    file = File.open("app/assets/stylesheets/main.css" , "w")

    # 変更内容を出力する。
    file.write(buffer)

    # クローズ
    file.close()

    #JSも修正
    file_js = File.open("app/assets/javascripts/main.js" , "r")
    buffer_js = file_js.read()
    if color_prm == "white"
      buffer_js.gsub!("242a3c","e6ecfe")#背景色
    else
      buffer_js.gsub!("e6ecfe","242a3c")#背景色
    end
    file_js = File.open("app/assets/javascripts/main.js" , "w")
    file_js.write(buffer_js)
    file_js.close()

    #画像をリネーム
    File.rename("app/assets/images/logo.png", "app/assets/images/logo_tmp.png") #現在の有効画像をtmp化
    File.rename("app/assets/images/logo_alt.png", "app/assets/images/logo.png") #現在の無効画像を有効化
    File.rename("app/assets/images/logo_tmp.png", "app/assets/images/logo_alt.png") #以前の有効画像を無効化

    redirect_to action: 'index'
  end

  #地図色のアンスコ以下を削除
  def remove_under_score(color_index)
    color_index = color_index.to_s
    if color_index.include?("_")
      return color_index.slice(2, 1)
    end
    return color_index
  end

  #選択されたデータ表示
  def show_data
    #csvをアドレスにくっつけてトップに遷移
    redirect_to ten_years_path(csv: params[:csv])
  end

  #公開中作品の公開停止
  def stop_open
    #csv/X_member/target.csvとtarget.txtをデフォルトに置き換え
    #csvのディレクトリ作成パス
    dir_name = (Rails.root.join('app', 'csv', session[:member_id].to_s + "_member")).to_s

    #続いて、デフォルトのcsvをコピーして既存を置き換え
    default_file_csv = (Rails.root.join('app', 'csv', "default.csv")).to_s
    FileUtils.cp(default_file_csv, dir_name + "/target.csv")
    #該当ファイル名を記載するテキストファイルをコピーして既存を置き換え
    default_file_txt = (Rails.root.join('app', 'csv', "target.txt")).to_s
    FileUtils.cp(default_file_txt, dir_name + "/target.txt")

    redirect_to action: 'index'
  end

end
