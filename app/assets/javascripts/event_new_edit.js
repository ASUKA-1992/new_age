window.onload = function() {
  // 全ての都道府県について、「汚染なし」と「沈没なし」にチェックを入れる
  // まずは汚染無し
  document.getElementById("P1-Hokkaido_0").checked = true;
  document.getElementById("P2-Aomori_0").checked = true;
  document.getElementById("P3-Iwate_0").checked = true;
  document.getElementById("P4-Akita_0").checked = true;
  document.getElementById("P5-Miyagi_0").checked = true;
  document.getElementById("P6-Yamagata_0").checked = true;
  document.getElementById("P7-Fukushima_0").checked = true;
  document.getElementById("P8-Ibaraki_0").checked = true;
  document.getElementById("P9-Tochigi_0").checked = true;
  document.getElementById("P10-Gunma_0").checked = true;
  document.getElementById("P11-Saitama_0").checked = true;
  document.getElementById("P12-Chiba_0").checked = true;
  document.getElementById("P13-Tokyo_0").checked = true;
  document.getElementById("P14-Kanagawa_0").checked = true;
  document.getElementById("P15-Niigata_0").checked = true;
  document.getElementById("P16-Toyama_0").checked = true;
  document.getElementById("P17-Ishikawa_0").checked = true;
  document.getElementById("P18-Fukui_0").checked = true;
  document.getElementById("P19-Yamanashi_0").checked = true;
  document.getElementById("P20-Nagano_0").checked = true;
  document.getElementById("P21-Gifu_0").checked = true;
  document.getElementById("P22-Shizuoka_0").checked = true;
  document.getElementById("P23-Aichi_0").checked = true;
  document.getElementById("P24-Mie_0").checked = true;
  document.getElementById("P25-Shiga_0").checked = true;
  document.getElementById("P26-Kyoto_0").checked = true;
  document.getElementById("P27-Osaka_0").checked = true;
  document.getElementById("P28-Hyogo_0").checked = true;
  document.getElementById("P29-Nara_0").checked = true;
  document.getElementById("P30-Wakayama_0").checked = true;
  document.getElementById("P31-Tottori_0").checked = true;
  document.getElementById("P32-Shimane_0").checked = true;
  document.getElementById("P33-Okayama_0").checked = true;
  document.getElementById("P34-Hiroshima_0").checked = true;
  document.getElementById("P35-Yamaguchi_0").checked = true;
  document.getElementById("P36-Tokushima_0").checked = true;
  document.getElementById("P37-Kagawa_0").checked = true;
  document.getElementById("P38-Ehime_0").checked = true;
  document.getElementById("P39-Kochi_0").checked = true;
  document.getElementById("P40-Fukuoka_0").checked = true;
  document.getElementById("P41-Saga_0").checked = true;
  document.getElementById("P42-Nagasaki_0").checked = true;
  document.getElementById("P43-Kumamoto_0").checked = true;
  document.getElementById("P44-Oita_0").checked = true;
  document.getElementById("P45-Miyazaki_0").checked = true;
  document.getElementById("P46-Kagoshima_0").checked = true;
  document.getElementById("P47-Okinawa_0").checked = true;

  // 続いて沈没なし
  document.getElementById("1-Hokkaido_0").checked = true;
  document.getElementById("2-Aomori_0").checked = true;
  document.getElementById("3-Iwate_0").checked = true;
  document.getElementById("4-Akita_0").checked = true;
  document.getElementById("5-Miyagi_0").checked = true;
  document.getElementById("6-Yamagata_0").checked = true;
  document.getElementById("7-Fukushima_0").checked = true;
  document.getElementById("8-Ibaraki_0").checked = true;
  document.getElementById("9-Tochigi_0").checked = true;
  document.getElementById("10-Gunma_0").checked = true;
  document.getElementById("11-Saitama_0").checked = true;
  document.getElementById("12-Chiba_0").checked = true;
  document.getElementById("13-Tokyo_0").checked = true;
  document.getElementById("14-Kanagawa_0").checked = true;
  document.getElementById("15-Niigata_0").checked = true;
  document.getElementById("16-Toyama_0").checked = true;
  document.getElementById("17-Ishikawa_0").checked = true;
  document.getElementById("18-Fukui_0").checked = true;
  document.getElementById("19-Yamanashi_0").checked = true;
  document.getElementById("20-Nagano_0").checked = true;
  document.getElementById("21-Gifu_0").checked = true;
  document.getElementById("22-Shizuoka_0").checked = true;
  document.getElementById("23-Aichi_0").checked = true;
  document.getElementById("24-Mie_0").checked = true;
  document.getElementById("25-Shiga_0").checked = true;
  document.getElementById("26-Kyoto_0").checked = true;
  document.getElementById("27-Osaka_0").checked = true;
  document.getElementById("28-Hyogo_0").checked = true;
  document.getElementById("29-Nara_0").checked = true;
  document.getElementById("30-Wakayama_0").checked = true;
  document.getElementById("31-Tottori_0").checked = true;
  document.getElementById("32-Shimane_0").checked = true;
  document.getElementById("33-Okayama_0").checked = true;
  document.getElementById("34-Hiroshima_0").checked = true;
  document.getElementById("35-Yamaguchi_0").checked = true;
  document.getElementById("36-Tokushima_0").checked = true;
  document.getElementById("37-Kagawa_0").checked = true;
  document.getElementById("38-Ehime_0").checked = true;
  document.getElementById("39-Kochi_0").checked = true;
  document.getElementById("40-Fukuoka_0").checked = true;
  document.getElementById("41-Saga_0").checked = true;
  document.getElementById("42-Nagasaki_0").checked = true;
  document.getElementById("43-Kumamoto_0").checked = true;
  document.getElementById("44-Oita_0").checked = true;
  document.getElementById("45-Miyazaki_0").checked = true;
  document.getElementById("46-Kagoshima_0").checked = true;
  document.getElementById("47-Okinawa_0").checked = true;

  // 画面にhiddenで持っている要素取得
  // カンマ区切りの沈没都道府県取得
  var str_1 = document.getElementById('prefecture_half_commma').value;
  var str_2 = document.getElementById('prefecture_commma').value;

  //沈没中
  if(str_1 != "" && str_1 != null){
    var str_1 = str_1.slice( 0, -1 ) ;
    // 都道府県をリストに変換
    var arr1 = str_1.split(',');
    // リストでループ
    for (var i = 0; i < arr1.length; i++){
      // 該当都道府県にチェックを入れる
      var wk_id = arr1[i] + "_1";
      document.getElementById(wk_id).checked = true;
    }
  }

  //沈没
  if(str_2 != "" && str_2 != null){
    var str_2 = str_2.slice( 0, -1 ) ;
    // 都道府県をリストに変換
    var arr2 = str_2.split(',');
    // リストでループ
    for (var i = 0; i < arr2.length; i++){
      // 該当都道府県にチェックを入れる
      var wk_id = arr2[i] + "_2";
      document.getElementById(wk_id).checked = true;
    }
  }

  // カンマ区切りの汚染都道府県取得
  var str_P1 = document.getElementById('pollution_half_commma').value;
  var str_P2 = document.getElementById('pollution_commma').value;

  //一部汚染
  if(str_P1 != "" && str_P1 != null){
    var str_P1 = str_P1.slice( 0, -1 ) ;
    // 都道府県をリストに変換
    var str_P1 = str_P1.split(',');
    // リストでループ
    for (var i = 0; i < str_P1.length; i++){
      // 該当都道府県にチェックを入れる
      var wk_id = "P" + str_P1[i] + "_1";
      document.getElementById(wk_id).checked = true;
    }
  }

  //全域汚染
  if(str_P2 != "" && str_P2 != null){
    var str_P2 = str_P2.slice( 0, -1 ) ;
    // 都道府県をリストに変換
    var str_P2 = str_P2.split(',');
    // リストでループ
    for (var i = 0; i < str_P2.length; i++){
      // 該当都道府県にチェックを入れる
      var wk_id = "P" + str_P2[i] + "_2";
      document.getElementById(wk_id).checked = true;
    }
  }
}

// 平常運転
function change_0(value){
  // 50%沈没、沈没から削除
  crear_1(value);
  crear_2(value);
}

// 50%沈没
function change_1(value){
  //沈没から削除
  crear_2(value);

  // カンマ区切りinputエリア
  var prefecture_half_commma = $('#prefecture_half_commma').val();
  // 文字列に追加
  prefecture_half_commma = (prefecture_half_commma + value + ",");
  $('#prefecture_half_commma').val(prefecture_half_commma);
}

// 沈没
function change_2(value){
  // 50%沈没から削除
  crear_1(value);

  // カンマ区切りinputエリア
  var prefecture_commma = $('#prefecture_commma').val();
  // 文字列に追加
  prefecture_commma = (prefecture_commma + value + ",");
  $('#prefecture_commma').val(prefecture_commma);
}

// 50%沈没から削除
function crear_1(value){
  // valueにカンマをつける
  var wk_value = value + ",";

  // カンマ区切りinputエリア
  var prefecture_half_commma = $('#prefecture_half_commma').val();
  //現在のinputエリアにチェックされた都道府県が含まれているか確認
  if (prefecture_half_commma.indexOf(wk_value) != -1) {
    // 含まれていた場合、文字列から排除
    prefecture_half_commma = prefecture_half_commma.replace(wk_value, '');
    $('#prefecture_half_commma').val(prefecture_half_commma);
  }
}

// 沈没から削除
function crear_2(value){
  // valueにカンマをつける
  var wk_value = value + ",";

  // カンマ区切りinputエリア
  var prefecture_commma = $('#prefecture_commma').val();
  //現在のinputエリアにチェックされた都道府県が含まれているか確認
  if (prefecture_commma.indexOf(wk_value) != -1) {
    // 含まれていた場合、文字列から排除
    prefecture_commma = prefecture_commma.replace(wk_value, '');
    $('#prefecture_commma').val(prefecture_commma);
  }
}

// 平常運転
function P_change_0(value){
  // 一部汚染、全域汚染から削除
  P_crear_1(value);
  P_crear_2(value);
}

// 一部汚染
function P_change_1(value){
  //全域汚染から削除
  P_crear_2(value);

  // カンマ区切りinputエリア
  var pollution_half_commma = $('#pollution_half_commma').val();
  // 文字列に追加
  pollution_half_commma = (pollution_half_commma + value + ",");
  $('#pollution_half_commma').val(pollution_half_commma);
}

// 全域汚染
function P_change_2(value){
  // 一部汚染から削除
  P_crear_1(value);

  // カンマ区切りinputエリア
  var pollution_commma = $('#pollution_commma').val();
  // 文字列に追加
  pollution_commma = (pollution_commma + value + ",");
  $('#pollution_commma').val(pollution_commma);
}

// 一部汚染から削除
function P_crear_1(value){
  // valueにカンマをつける
  var wk_value = value + ",";

  // カンマ区切りinputエリア
  var pollution_half_commma = $('#pollution_half_commma').val();
  //現在のinputエリアにチェックされた都道府県が含まれているか確認
  if (pollution_half_commma.indexOf(wk_value) != -1) {
    // 含まれていた場合、文字列から排除
    pollution_half_commma = pollution_half_commma.replace(wk_value, '');
    $('#pollution_half_commma').val(pollution_half_commma);
  }
}

// 全域汚染から削除
function P_crear_2(value){
  // valueにカンマをつける
  var wk_value = value + ",";

  // カンマ区切りinputエリア
  var pollution_commma = $('#pollution_commma').val();
  //現在のinputエリアにチェックされた都道府県が含まれているか確認
  if (pollution_commma.indexOf(wk_value) != -1) {
    // 含まれていた場合、文字列から排除
    pollution_commma = pollution_commma.replace(wk_value, '');
    $('#pollution_commma').val(pollution_commma);
  }
}

// 2011-01-01が選択された場合、人口増減と沈没都道府県を非活性にする
$(document).ready(function(){
  $("#saelect_date").change(function(){
    //ひとまず先送り 3/15
  });
});
