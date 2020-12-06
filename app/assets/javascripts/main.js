$(function(){

  // 年閲覧可能有無判定クッキー削除
  document.cookie = "click_able_year=; max-age=0";
  // クッキー初期値を2011にする
  document.cookie = "click_able_year=" + 2011;

  //初期グローバル変数宣言
  //性別年齢別人口用変数
  var F1910;
  var F1920;
  var F1930;
  var F1940;
  var F1950;
  var F1960;
  var F1970;
  var F1980;
  var F1990;
  var F2000;
  var F2010;
  var M1910;
  var M1920;
  var M1930;
  var M1940;
  var M1950;
  var M1960;
  var M1970;
  var M1980;
  var M1990;
  var M2000;
  var M2010;
  // 都道府県別人口変数
  var Hokkaido;
  var Aomori;
  var Iwate;
  var Akita;
  var Miyagi;
  var Yamagata;
  var Fukushima;
  var Ibaraki;
  var Tochigi;
  var Gunma;
  var Saitama;
  var Chiba;
  var Tokyo;
  var Kanagawa;
  var Niigata;
  var Toyama;
  var Ishikawa;
  var Fukui;
  var Yamanashi;
  var Nagano;
  var Gifu;
  var Shizuoka;
  var Aichi;
  var Mie;
  var Shiga;
  var Kyoto;
  var Osaka;
  var Hyogo;
  var Nara;
  var Wakayama;
  var Tottori;
  var Shimane;
  var Okayama;
  var Hiroshima;
  var Yamaguchi;
  var Tokushima;
  var Kagawa;
  var Ehime;
  var Kochi;
  var Fukuoka;
  var Saga;
  var Nagasaki;
  var Kumamoto;
  var Oita;
  var Miyazaki;
  var Kagoshima;
  var Okinawa;
  var Others;

  //地図の地域情報設定
  //{"code":[地域のコード], "name": [地域の名前], "color":[地域につける色], "hoverColor":[地域をマウスでホバーしたときの色], "prefectures":[地域に含まれる都道府県のコード]}
  var color_0 = "#52d49c";
  var areas = [
    {"code":1,"name":"","color":color_0,"prefectures":[1]},
    {"code":2,"name":"","color":color_0,"prefectures":[2]},
    {"code":3,"name":"","color":color_0,"prefectures":[3]},
    {"code":4,"name":"","color":color_0,"prefectures":[4]},
    {"code":5,"name":"","color":color_0,"prefectures":[5]},
    {"code":6,"name":"","color":color_0,"prefectures":[6]},
    {"code":7,"name":"","color":color_0,"prefectures":[7]},
    {"code":8,"name":"","color":color_0,"prefectures":[8]},
    {"code":9,"name":"","color":color_0,"prefectures":[9]},
    {"code":10,"name":"","color":color_0,"prefectures":[10]},
    {"code":11,"name":"","color":color_0,"prefectures":[11]},
    {"code":12,"name":"","color":color_0,"prefectures":[12]},
    {"code":13,"name":"","color":color_0,"prefectures":[13]},
    {"code":14,"name":"","color":color_0,"prefectures":[14]},
    {"code":15,"name":"","color":color_0,"prefectures":[15]},
    {"code":16,"name":"","color":color_0,"prefectures":[16]},
    {"code":17,"name":"","color":color_0,"prefectures":[17]},
    {"code":18,"name":"","color":color_0,"prefectures":[18]},
    {"code":19,"name":"","color":color_0,"prefectures":[19]},
    {"code":20,"name":"","color":color_0,"prefectures":[20]},
    {"code":21,"name":"","color":color_0,"prefectures":[21]},
    {"code":22,"name":"","color":color_0,"prefectures":[22]},
    {"code":23,"name":"","color":color_0,"prefectures":[23]},
    {"code":24,"name":"","color":color_0,"prefectures":[24]},
    {"code":25,"name":"","color":color_0,"prefectures":[25]},
    {"code":26,"name":"","color":color_0,"prefectures":[26]},
    {"code":27,"name":"","color":color_0,"prefectures":[27]},
    {"code":28,"name":"","color":color_0,"prefectures":[28]},
    {"code":29,"name":"","color":color_0,"prefectures":[29]},
    {"code":30,"name":"","color":color_0,"prefectures":[30]},
    {"code":31,"name":"","color":color_0,"prefectures":[31]},
    {"code":32,"name":"","color":color_0,"prefectures":[32]},
    {"code":33,"name":"","color":color_0,"prefectures":[33]},
    {"code":34,"name":"","color":color_0,"prefectures":[34]},
    {"code":35,"name":"","color":color_0,"prefectures":[35]},
    {"code":36,"name":"","color":color_0,"prefectures":[36]},
    {"code":37,"name":"","color":color_0,"prefectures":[37]},
    {"code":38,"name":"","color":color_0,"prefectures":[38]},
    {"code":39,"name":"","color":color_0,"prefectures":[39]},
    {"code":40,"name":"","color":color_0,"prefectures":[40]},
    {"code":41,"name":"","color":color_0,"prefectures":[41]},
    {"code":42,"name":"","color":color_0,"prefectures":[42]},
    {"code":43,"name":"","color":color_0,"prefectures":[43]},
    {"code":44,"name":"","color":color_0,"prefectures":[44]},
    {"code":45,"name":"","color":color_0,"prefectures":[45]},
    {"code":46,"name":"","color":color_0,"prefectures":[46]},
    {"code":47,"name":"","color":color_0,"prefectures":[47]},
  ];

  //以下、初期表示設定
  //出来事数種億
  var data_max = $('#data_div').children("input").length;
  $("#data_max").val(data_max);

  // カンマ区切り初期データ取得・配列化(基本は2011/1/1のデータ)
  var first_data = $("#data_0").val();
  var data_arr = first_data.split(',');

  // 配列からダブルコーテーション削除
  data_arr = cut_quotation_start(data_arr);

  // 地図の色別説明文設定
  $("#color_1").addClass("div_display_none");
  $("#color_2").addClass("div_display_none");
  $("#color_3").addClass("div_display_none");
  $("#color_5").addClass("div_display_none");
  $("#color_6").addClass("div_display_none");

  // データセット
  set_data_common(data_arr);

  // 前へボタン非表示
  $(".back").addClass("div_display_none");

  // データセット
  function set_data_common(data_arr){
    // 出来事日付設定
    // 曜日配列作成
    var week_arr=["日","月","火","水","木","金","土"];
    // 文字列日付をdate型に変換
    var date = new Date(data_arr[1]);
    // 曜日取得
    var week = week_arr[date.getDay()];
    // 日付を表示用に変換
    var year = date.getFullYear();
    var month = date.getMonth()+1;
    var day = date.getDate();
    var date_disp = year + '/' + month + '/' + day + '(' + week + ')';
    $("#event_date").text(date_disp);

    // 出来事タイトル設定
    $("#event_title").text(data_arr[122]);
    // 出来事本文設定
    // まずは改行コード置き換え
    wk_detail = data_arr[123].replace(/\\r\\n/g, '<br>');
    $("#event_main").html(wk_detail);

    // スマートフォンレスポンシブ対応
    $("#sp_event_date").text(date_disp);
    $("#sp_event_title").text(data_arr[122]);
    $("#sp_event_main").html(wk_detail);


    // 性別年齢別人口チャート作成
    set_glaph_age(data_arr);

    // 都道府県別人口チャート作成
    set_glaph_prefecture(data_arr);

    // 地図設定
    set_new_map();

    // クッキー設定
    cookie_val = get_cookie_val();
    //ログインしている場合、実行しない
    if ($('#login').val() == "false"){
      if(cookie_val < year){
        // 出来事の年がクッキーより大きい場合に限り、クッキーを更新
        document.cookie = "click_able_year=" + year;
        cookie_val = year;
      }
      /*
      // クッキーの値をもとに、押下できる年を設定
      for( var i = 2011; i <= 2020; i++) {
        var select_year_id = "#select_" + String(i);
        if(i <= cookie_val){
          $(select_year_id).addClass("div_cursor_hand");
          $(select_year_id).addClass("color_year_date");
        } else {
          $(select_year_id).removeClass("div_cursor_hand");
          $(select_year_id).removeClass("color_year_date");
        }
      }
      */
    }

    // 2020年になったときに性別・年齢別グラフが崩れないため、
    // 隠し文字を入れているが、その文字を背景色と同じ色にする
    jQuery('tspan').each(function(i){
      var tmp_str = jQuery(this).text();
      if (tmp_str.match(/X2000/)){
        $(this).html(tmp_str.replace(/X/g,'<span style="color:#061a2b">X</span>'));
      }
    });
  }

  // クッキーの値取得
  function get_cookie_val(){
    // クッキーに入っている値を確認
    var tmp_cookie = document.cookie.split('; '); // クッキー取得
    for(var i=0;i<tmp_cookie.length;i++){ // 該当クッキーをループで探す
      var data_cookie = tmp_cookie[i].split('=');
      if (data_cookie[0] == "click_able_year"){
        return data_cookie[1];
      }
    }
    return 2011; // クッキーに値がない場合(あり得ないが)、2011を返却
  }

  // ダブルコーテーション削除開始
  function cut_quotation_start(data_arr){
    for( var i = 0; i < data_arr.length; i++) {
      var str = data_arr[i];
      // 空文字の場合、次のループへ
      if(str == "" || str == null){
        continue;
      }

      if(i==1||i<=123){ //数値の要素を記載する
        // 文字列の場合
        // 最終文字取得
        var last = str.slice(-1);
        // 最終文字が「]」の場合、両サイドの「"]」を削除
        if(last == "]"){
          data_arr[i] = str.trim().slice(1,-2);
        } else {
          // 両サイドの「"]」を削除
          data_arr[i] = str.trim().slice(1,-1);
        }

      } else {
        //数値の場合
        data_arr[i] = Number(str.trim().slice(1,-1));
      }
    }
    return data_arr;
  }

  //戻るボタン
  $(".back").click(function(){
    $("#overlay").fadeIn(200); //二度押しを防ぐloading表示
    // 次のカウント取得
    var next_now = Number($("#data_now").val()) - 1;
    // マイナスの場合、以降の処理を実施しない
    if(next_now < 0){
      next_now = 0;
      return;
    }

    // 次へボタン表示
    $(".next").removeClass("div_display_none");
    // カウントが0の場合、戻るボタンを表示しない
    if (next_now == 0){
      $(".back").addClass("div_display_none");
    }

    click_btn_common(next_now);
    $("#overlay").fadeOut(500);
  });

  // 次へボタン
  $(".next").click(function(){
    next_click();
  });
  // 自動更新のため、別関数化
  var next_click = function(){
    $("#overlay").fadeIn(200); //二度押しを防ぐloading表示
    // 次のカウント取得
    var next_now = Number($("#data_now").val()) + 1;
    // 最大値を超えるの場合、以降の処理を実施しない
    if(data_max <= next_now){
      next_now = data_max - 1;
      return;
    }

    // 戻るボタン表示
    $(".back").removeClass("div_display_none");
    // カウントが最大値の場合、次へボタンを表示しない
    if (next_now == data_max -1 ){
      $(".next").addClass("div_display_none");
    }

    click_btn_common(next_now);
    $("#overlay").fadeOut(500);
  }

  // 前/次へボタンクリック共通
  function click_btn_common(next_now){
    // 地図の色別説明文設定
    $("#color_1").addClass("div_display_none");
    $("#color_2").addClass("div_display_none");
    $("#color_3").addClass("div_display_none");
    $("#color_5").addClass("div_display_none");
    $("#color_6").addClass("div_display_none");

    // 前/次のデータを取得
    $("#data_now").val(next_now);
    var data_now = "#data_" + $("#data_now").val();
    var data_next = $(data_now).val();
    var data_arr = data_next.split(',');

    // 配列からダブルコーテーション削除
    data_arr = cut_quotation_start(data_arr);

    // 地図の色を変換
    areas[0]["color"] = get_color(data_arr[74]);	// 北海道
    areas[1]["color"] = get_color(data_arr[75]);	// 青森
    areas[2]["color"] = get_color(data_arr[76]);	// 岩手
    areas[3]["color"] = get_color(data_arr[77]);	// 秋田
    areas[4]["color"] = get_color(data_arr[78]);	// 宮城
    areas[5]["color"] = get_color(data_arr[79]);	// 山形
    areas[6]["color"] = get_color(data_arr[80]);	// 福島
    areas[7]["color"] = get_color(data_arr[81]);	// 茨城
    areas[8]["color"] = get_color(data_arr[82]);	// 栃木
    areas[9]["color"] = get_color(data_arr[83]);	// 群馬
    areas[10]["color"] = get_color(data_arr[84]);	// 埼玉
    areas[11]["color"] = get_color(data_arr[85]);	// 千葉
    areas[12]["color"] = get_color(data_arr[86]);	// 東京
    areas[13]["color"] = get_color(data_arr[87]);	// 神奈川
    areas[14]["color"] = get_color(data_arr[88]);	// 新潟
    areas[15]["color"] = get_color(data_arr[89]);	// 富山
    areas[16]["color"] = get_color(data_arr[90]);	// 石川
    areas[17]["color"] = get_color(data_arr[91]);	// 福井
    areas[18]["color"] = get_color(data_arr[92]);	// 山梨
    areas[19]["color"] = get_color(data_arr[93]);	// 長野
    areas[20]["color"] = get_color(data_arr[94]);	// 岐阜
    areas[21]["color"] = get_color(data_arr[95]);	// 静岡
    areas[22]["color"] = get_color(data_arr[96]);	// 愛知
    areas[23]["color"] = get_color(data_arr[97]);	// 三重
    areas[24]["color"] = get_color(data_arr[98]);	// 滋賀
    areas[25]["color"] = get_color(data_arr[99]);	// 京都
    areas[26]["color"] = get_color(data_arr[100]);	// 大阪
    areas[27]["color"] = get_color(data_arr[101]);	// 兵庫
    areas[28]["color"] = get_color(data_arr[102]);	// 奈良
    areas[29]["color"] = get_color(data_arr[103]);	// 和歌山
    areas[30]["color"] = get_color(data_arr[104]);	// 鳥取
    areas[31]["color"] = get_color(data_arr[105]);	// 島根
    areas[32]["color"] = get_color(data_arr[106]);	// 岡山
    areas[33]["color"] = get_color(data_arr[107]);	// 広島
    areas[34]["color"] = get_color(data_arr[108]);	// 山口
    areas[35]["color"] = get_color(data_arr[109]);	// 徳島
    areas[36]["color"] = get_color(data_arr[110]);	// 香川
    areas[37]["color"] = get_color(data_arr[111]);	// 愛媛
    areas[38]["color"] = get_color(data_arr[112]);	// 高知
    areas[39]["color"] = get_color(data_arr[113]);	// 福岡
    areas[40]["color"] = get_color(data_arr[114]);	// 佐賀
    areas[41]["color"] = get_color(data_arr[115]);	// 長崎
    areas[42]["color"] = get_color(data_arr[116]);	// 熊本
    areas[43]["color"] = get_color(data_arr[117]);	// 大分
    areas[44]["color"] = get_color(data_arr[118]);	// 宮崎
    areas[45]["color"] = get_color(data_arr[119]);	// 鹿児島
    areas[46]["color"] = get_color(data_arr[120]);	// 沖縄

    // データセット
    set_data_common(data_arr);
  }

  //都道府県の色を設定する
  function get_color(target){
    // アンスコ以下を削除
    var idx = target.indexOf("_");
    if (-1 < idx) {
      target = target.substring(0, idx);
    }

    var color = "#52d49c";
    if(target == 1){
      //死者:10-50人
      color = "#ffd700";
      // 色説明を表示
      $("#color_1").removeClass("div_display_none");

    } else if(target == 2){
      //死者:51人以上
      color = "#ff0000";
      // 色説明を表示
      $("#color_2").removeClass("div_display_none");

    } else if(target == 3) {
      //50%沈没
      color = "#6495ed";
      // 色説明を表示
      $("#color_3").removeClass("div_display_none");

    } else if(target == 4){
      //完全沈没
      color = "#242a3c";

    } else if(target == 5){
      //一部放射能汚染
      color = "#da70d6";
      // 色説明を表示
      $("#color_5").removeClass("div_display_none");

    } else if(target == 6) {
      //全域放射能汚染
      color = "#8a2be2";
      // 色説明を表示
      $("#color_6").removeClass("div_display_none");
    }

    return color;
  }

  // グラフの値置き換え
  function set_glaph_age(data_arr){
    F1910 = Number(data_arr[4]);
    F1920 = Number(data_arr[5]);
    F1930 = Number(data_arr[6]);
    F1940 = Number(data_arr[7]);
    F1950 = Number(data_arr[8]);
    F1960 = Number(data_arr[9]);
    F1970 = Number(data_arr[10]);
    F1980 = Number(data_arr[11]);
    F1990 = Number(data_arr[12]);
    F2000 = Number(data_arr[13]);
    F2010 = Number(data_arr[14]);
    M1910 = Number(data_arr[15]);
    M1920 = Number(data_arr[16]);
    M1930 = Number(data_arr[17]);
    M1940 = Number(data_arr[18]);
    M1950 = Number(data_arr[19]);
    M1960 = Number(data_arr[20]);
    M1970 = Number(data_arr[21]);
    M1980 = Number(data_arr[22]);
    M1990 = Number(data_arr[23]);
    M2000 = Number(data_arr[24]);
    M2010 = Number(data_arr[25]);

    // 性別年齢別グラフ作成
    set_glaph_gender();
  }

  // 性別年齢別グラフ作成
  function set_glaph_gender(){
    // 性別・年齢別人口の年齢取得
    var target_year = $("#event_date").text().substr(0,4);

    // 性別年齢別人口チャート作成
    var categories = [
      '2010~<br/>'   + 0 + "~" + (target_year - 2010) + "歳",
      '2000~09<br/>' + (target_year - 2009) + "~" + (target_year - 2000) + "歳",
      '1990~99<br/>' + (target_year - 1999) + "~" + (target_year - 1990) + "歳",
      '1980~89<br/>' + (target_year - 1989) + "~" + (target_year - 1980) + "歳",
      '1970~79<br/>' + (target_year - 1979) + "~" + (target_year - 1970) + "歳",
      '1960~69<br/>' + (target_year - 1969) + "~" + (target_year - 1960) + "歳",
      '1950~59<br/>' + (target_year - 1959) + "~" + (target_year - 1950) + "歳",
      '1940~49<br/>' + (target_year - 1949) + "~" + (target_year - 1940) + "歳",
      '1930~39<br/>' + (target_year - 1939) + "~" + (target_year - 1930) + "歳",
      '1920~29<br/>' + (target_year - 1929) + "~" + (target_year - 1920) + "歳",
      '~1919<br/>'   + (target_year - 1919) + "歳~"
    ];

    // 性別・年齢別人口の注釈を作成
    $("#age_glaph_note").text(target_year + '/1/1時点の年齢');

    // 年齢グラフサイズ通常時
    var woman_width = 145
    var man_width = 205
    // ラベルフォントサイズ通常時
    var label_font_size = '11px'
    //ウィンドウサイズ取得
    var window_width = $(window).width();
    if(700 < window_width && window_width <= 1250){
      woman_width = window_width * 0.165;
      man_width = window_width * 0.22;
      label_font_size = '9px';

    } else if (window_width <= 700) {
      woman_width = window_width * 0.37;
      man_width = window_width * 0.51;
      label_font_size = '9px';
    }

    Highcharts.chart('left', {
      chart: {
        type: 'bar',
        marginRight: 1,
        backgroundColor: 'rgba(0,0,0,0)',
        height: 350,
        width: woman_width
      },
      yAxis: {
        min: 0,
        reversed: true,
        title: {
          enabled: false
        },
        max: 10000000,
        labels: { 　
          allowDecimals: true,
          formatter: function() {
            return Highcharts.numberFormat(this.value / 100000, -1, '.', ',') +''
          }
        }
      },
      xAxis: {
        visible: false,
        reversed: false,
      },
      title: {
        text: ''
      },
      legend: {
        layout: 'vertical',
        align: 'left',
        verticalAlign: 'top',
        x: 15,
        y: 10,
        floating: true,
        backgroundColor: ((Highcharts.theme && Highcharts.theme.legendBackgroundColor) || 'rgba(0,0,0,0)'),
        symbolHeight: .001,
        symbolWidth: .001,
        symbolRadius: .001,
        itemStyle:{'color':'#f0f8ff'}
      },
      // マウスカーソルが当たった際のtooltipを非表示
      tooltip: {
        enabled: false // カーソルを置いたときに吹き出しを表示しない
      },
      series: [{
        color: '#add8e6',
        name: '女性',
        animation: false,
        data: [
          F2010, F2000, F1990, F1980, F1970,
          F1960, F1950, F1940, F1930, F1920,
          F1910
        ],
        events: {
            legendItemClick: function() {
              return false;
            }
        }

      }]
    });

    Highcharts.chart('right', {
      chart: {
        type: 'bar',
        marginRight: 1,
        backgroundColor: 'rgba(0,0,0,0)',
        height: 350,
        width: man_width
      },
      yAxis: {
        min: 0,
        enabled: false,
        title: {
          enabled: false
        },
        max: 10000000,
        labels: { 　
          allowDecimals: true,
          formatter: function() {
            return Highcharts.numberFormat(this.value / 100000, -1, '.', ',') +''
          }
        }
      },
      xAxis: {
        reversed: false,
        categories: categories,
        tickLength: 0,
        labels: {
          style: {
            fontSize: label_font_size,
            color: '#f0f8ff'
            , 'text-align': 'center'
          }
        }
      },
      title: {
        text: ''
      },
      legend: {
        layout: 'vertical',
        align: 'right',
        verticalAlign: 'top',
        x: -10,
        y: 10,
        floating: true,
        backgroundColor: ((Highcharts.theme && Highcharts.theme.legendBackgroundColor) || 'rgba(0,0,0,0)'),
        symbolHeight: .001,
        symbolWidth: .001,
        symbolRadius: .001,
        itemStyle:{'color':'#f0f8ff'}
      },
      // マウスカーソルが当たった際のtooltipを非表示
      tooltip: {
        enabled: false // カーソルを置いたときに吹き出しを表示しない
      },
      series: [{
        color: '#add8e6',
        name: '男性',
        animation: false,
        data: [
          M2010, M2000, M1990, M1980, M1970,
          M1960, M1950, M1940, M1930, M1920,
          M1910
        ],
        events: {
            legendItemClick: function() {
              return false;
            }
        }
      }]
    });
  }

  // グラフの値置き換え
  function set_glaph_prefecture(data_arr){
    Hokkaido	=Number(data_arr[26]);
    Aomori	=Number(data_arr[27]);
    Iwate	=Number(data_arr[28]);
    Akita	=Number(data_arr[29]);
    Miyagi	=Number(data_arr[30]);
    Yamagata	=Number(data_arr[31]);
    Fukushima	=Number(data_arr[32]);
    Ibaraki	=Number(data_arr[33]);
    Tochigi	=Number(data_arr[34]);
    Gunma	=Number(data_arr[35]);
    Saitama	=Number(data_arr[36]);
    Chiba	=Number(data_arr[37]);
    Tokyo	=Number(data_arr[38]);
    Kanagawa	=Number(data_arr[39]);
    Niigata	=Number(data_arr[40]);
    Toyama	=Number(data_arr[41]);
    Ishikawa	=Number(data_arr[42]);
    Fukui	=Number(data_arr[43]);
    Yamanashi	=Number(data_arr[44]);
    Nagano	=Number(data_arr[45]);
    Gifu	=Number(data_arr[46]);
    Shizuoka	=Number(data_arr[47]);
    Aichi	=Number(data_arr[48]);
    Mie	=Number(data_arr[49]);
    Shiga	=Number(data_arr[50]);
    Kyoto	=Number(data_arr[51]);
    Osaka	=Number(data_arr[52]);
    Hyogo	=Number(data_arr[53]);
    Nara	=Number(data_arr[54]);
    Wakayama	=Number(data_arr[55]);
    Tottori	=Number(data_arr[56]);
    Shimane	=Number(data_arr[57]);
    Okayama	=Number(data_arr[58]);
    Hiroshima	=Number(data_arr[59]);
    Yamaguchi	=Number(data_arr[60]);
    Tokushima	=Number(data_arr[61]);
    Kagawa	=Number(data_arr[62]);
    Ehime	=Number(data_arr[63]);
    Kochi	=Number(data_arr[64]);
    Fukuoka	=Number(data_arr[65]);
    Saga	=Number(data_arr[66]);
    Nagasaki	=Number(data_arr[67]);
    Kumamoto	=Number(data_arr[68]);
    Oita	=Number(data_arr[69]);
    Miyazaki	=Number(data_arr[70]);
    Kagoshima	=Number(data_arr[71]);
    Okinawa	=Number(data_arr[72]);
    Others	=Number(data_arr[73]);

    create_glaph_prefecture();
  }

  // 都道府県別人口グラフ作成
  function create_glaph_prefecture(){

    // ラベルフォントサイズ通常時
    var label_font_size = '11px'
    // チャートのレイアウト
    chart_type = 'column'; //デフォルトは横
    // チャートの高さ
    glaph_height = '380px';
    // 並び順設定
    reversed_flg = false;
    //ウィンドウサイズ取得
    var window_width = $(window).width();
    if(700 < window_width && window_width <= 1250){
      label_font_size = '7px';

    } else if (window_width <= 700) {
      // スマホは縦グラフ
      chart_type = 'bar';
      // 高さ調整
      glaph_height = '800px';
      // 並び順変更
      reversed_flg = true;
    }

    // 都道府県別人口チャート作成
    var categories_prefecture = [
      '北海道','青森県','岩手県','秋田県','宮城県','山形県','福島県'
      ,'茨城県','栃木県','群馬県','埼玉県','千葉県','東京都','神奈川県'
      ,'新潟県','富山県','石川県','福井県'
      ,'山梨県','長野県','岐阜県','静岡県','愛知県','三重県'
      ,'滋賀県','京都府','大阪府','兵庫県','奈良県','和歌山県'
      ,'鳥取県','島根県','岡山県','広島県','山口県'
      ,'徳島県','香川県','愛媛県','高知県'
      ,'福岡県','佐賀県','長崎県','熊本県','大分県','宮崎県','鹿児島県','沖縄県'
      ,'海外'
    ];

    Highcharts.chart('prefecture_glaph', {
      chart: {
        type: chart_type,
        marginRight: 1,
        backgroundColor: 'rgba(0,0,0,0)',
        height: glaph_height
      },
      yAxis: {
        min: 0,
        enabled: false,
        title: {
          enabled: false
        },
        labels: { 　
          allowDecimals: true,
          formatter: function() {
            return Highcharts.numberFormat(this.value / 100000, -1, '.', ',') +''
          }
        }
      },
      xAxis: [{
        reversed: false,
        categories: categories_prefecture,
        tickLength: 0,
        reversed: reversed_flg,
        labels: {
          style: {
            fontSize: label_font_size,
            color: '#f0f8ff'
          }
        }
      }],
      title: {
        text: ''
      },
      // マウスカーソルが当たった際のtooltipを非表示
      tooltip: {
        enabled: false // カーソルを置いたときに吹き出しを表示しない
      },
      series: [{
        color: '#add8e6',
        animation: false,

        data: [
          Hokkaido,Aomori,Iwate,Akita,Miyagi,Yamagata,Fukushima
          ,Ibaraki,Tochigi,Gunma,Saitama,Chiba,Tokyo
          ,Kanagawa,Niigata,Toyama,Ishikawa,Fukui
          ,Yamanashi,Nagano,Gifu,Shizuoka,Aichi,Mie
          ,Shiga,Kyoto,Osaka,Hyogo,Nara,Wakayama
          ,Tottori,Shimane,Okayama,Hiroshima,Yamaguchi
          ,Tokushima,Kagawa,Ehime,Kochi
          ,Fukuoka,Saga,Nagasaki,Kumamoto,Oita,Miyazaki,Kagoshima,Okinawa
          ,Others
        ],
        events: {
            legendItemClick: function() {
              return false;
            }
        }
      }]
    });


    var total = Hokkaido + Aomori + Iwate + Akita + Miyagi + Yamagata + Fukushima
             + Ibaraki + Tochigi + Gunma + Saitama + Chiba + Tokyo + Kanagawa
             + Niigata + Toyama + Ishikawa + Fukui
             + Yamanashi + Nagano + Gifu + Shizuoka + Aichi + Mie
             + Shiga + Kyoto + Osaka + Hyogo + Nara + Wakayama
             + Tottori + Shimane + Okayama + Hiroshima + Yamaguchi
             + Tokushima + Kagawa + Ehime + Kochi
             + Fukuoka + Saga + Nagasaki + Kumamoto + Oita + Miyazaki + Kagoshima + Okinawa
             + Others;
    var capital_area = Saitama + Chiba + Tokyo + Kanagawa;
    var capital_rate = capital_area / total * 1000;
    capital_rate = Math.round(capital_rate) / 10;
    $("#capital_rate").text("1都3県集中率:" + capital_rate + "%");
  }

  function set_new_map(){
    // 地図サイズ通常時
    var map_width = 480
    //ウィンドウサイズ取得
    var window_width = $(window).width();
    if(700 < window_width && window_width <= 1250){
      map_width = window_width * 0.5;

    } else if (window_width <= 700) {
      map_width = window_width * 0.9;
    }

    $("#map").children("canvas").remove();
    $("#map").japanMap(
      {
        areas  : areas, //上で設定したエリアの情報
        selection : "prefecture", //選ぶことができる範囲(県→prefecture、エリア→area)
        borderLineWidth: 0, //線の幅
        drawsBoxLine : false, //canvasを線で囲む場合はtrue
        movesIslands : true, //南西諸島を左上に移動させるときはtrue、移動させないときはfalse
        width: map_width, //canvasのwidth。別途heightも指定可。
        backgroundColor: "rgba(0,0,0,0)", //canvasの背景色
      }
    );
  }

  // 各年の先頭のジャンプ
  $("#select_2011").click(function(){search_year("2011")});
  $("#select_2012").click(function(){search_year("2012")});
  $("#select_2013").click(function(){search_year("2013")});
  $("#select_2014").click(function(){search_year("2014")});
  $("#select_2015").click(function(){search_year("2015")});
  $("#select_2016").click(function(){search_year("2016")});
  $("#select_2017").click(function(){search_year("2017")});
  $("#select_2018").click(function(){search_year("2018")});
  $("#select_2019").click(function(){search_year("2019")});
  $("#select_2020").click(function(){search_year("2020")});
  function search_year(year){
    // クッキーの値よりyearが大きい場合、処理を実施しない
    /*if (get_cookie_val() < year){
      // ログインしてない時のみ
      if ($('#login').val() == "false"){
        return;
      }
    }*/

    //2011年押下の場合のみ、戻るボタン非表示処理
    // 次へボタン表示
    if(year == 2011){
      $(".next").removeClass("div_display_none");
      $(".back").addClass("div_display_none");
    } else {
      $(".back").removeClass("div_display_none");
    }

    $("#overlay").fadeIn(200); //二度押しを防ぐloading表示
    var data_max = $("#data_max").val();
    for(var i = 0; i < data_max; i++) {
      // inputのデータ取得
      var data_now = "#data_" + i;
      var data_str = $(data_now).val();
      var data_arr = data_str.split(',');
      //年があるか確認
      if(-1 < data_arr[1].indexOf(year)){
        click_btn_common(i);
        break;
      }
    }
    $("#overlay").fadeOut(500);
  }

	//ウィンドウリサイズ処理
  $(window).resize(function() {
    // 地図サイズ修正
    set_new_map();

    //性別年齢別グラフサイズ修正
    set_glaph_gender();

    // 都道府県別人口グラフ作成
    create_glaph_prefecture();
  });

});

// ウィンドウ読み込み時に閲覧済みダイアログがあれば非表示
window.onload = function () {

  not_first_view_flg = false;
  //この日最初の表示でなければ、ダイアログをクローズする
  var tmp_cookie = document.cookie.split('; '); // クッキー取得
  for(var i=0;i<tmp_cookie.length;i++){ // 該当クッキーをループで探す
    var data_cookie = tmp_cookie[i].split('=');
    if (data_cookie[0] == "not_first_view"){
      if (data_cookie[1] == "true"){
        not_first_view_flg = true;
        break;
      }
    }
  }

  // この日最初の訪問でない場合、ダイアログを表示させない
  if(not_first_view_flg){
    close_dialog();
  } else {
    // ダイアログ表示判定クッキー作成
    var expire = new Date();
    expire.setTime( expire.getTime() + 1000 * 3600 * 24 );
    document.cookie = 'not_first_view=true; expires=' + expire.toUTCString();

    //ダイアログをオープン
    var targetElement = document.getElementById("detail_dialog");
    targetElement.style.display = "block";
  }

};

// CLOSEボタン押下
function close_dialog_click(){
  close_dialog();
}

// ダイアログクロ―ズ
function close_dialog(){
  var targetElement = document.getElementById("detail_dialog");
  targetElement.style.display = "none";

  // モーダル非表示
  $("#dialog_modal").addClass("div_display_none");
  return;
}
