// クリックしたとき
$(document).click(function(e) { main(); });
// 初期読み込み
$(document).ready(function(){ main(); });

function main(){
  var total = 0;
  // 入力した値を取得
  $("#age_new_table .age_new_input").each(function () {
    var get_textbox_value = $(this).val();
    if ($.isNumeric(get_textbox_value)) {
      total += parseFloat(get_textbox_value);
    }
  });
  $('#total').val(total);

  // 総人口取得
  var total_population = $('#total_population').val();
  // 総人口と入力した値の差分を表示
  var diff = parseFloat(total_population) - total;
  $('#diff').val(diff);

  // 差分が0以外の場合、コンファームを表示する登録ボタンとする
  $('#suibmit_btn').hide();
  $('#suibmit_btn_confirm').show();
  if(diff == 0){
    $('#suibmit_btn').show();
    $('#suibmit_btn_confirm').hide();
  }
}

// 割合を指定して人口増減設定
function calculate(minus_flg){
  // 割合取得
  var rate = document.getElementById("calculate_rate").value;
  //alert(rate); //デバッグ用

  if(rate == ""){
    return;
  }

  // 計算要チェックボックス
  checkbox_list = document.getElementsByClassName("cal_checkbox");
  for (var i = 0; i < checkbox_list.length; i++){
    if(checkbox_list[i].checked){
      //alert(checkbox_list[i].value); //デバッグ用
      // このイベント直前の人口を取得
      var wk_before_id = "#before_" + checkbox_list[i].value;
      var wk_before_num = $(wk_before_id).val(); //まずは素直に取り出し
      wk_before_num = wk_before_num.replace(/,/g,""); //「,」を削除
      //alert(wk_before_num); //デバッグ用

      //選択された割合で計算
      wk_cal_num = parseInt(wk_before_num * rate);
      // 減少フラグが立っている場合、マイナス化する
      if(minus_flg){
        wk_cal_num = wk_cal_num * -1;
      }

      // インプットエリアに計算した値を入れる
      var wk_cal_id = "#input_" + checkbox_list[i].value;
      $(wk_cal_id).val(wk_cal_num);

      // チェックボックスのチェックを外す
      //checkbox_list[i].checked = false;
    }
  }
}
