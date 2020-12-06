// クリックしたとき
$(document).click(function(e) { main(); });
// 初期読み込み
$(document).ready(function(){ main(); });

function main(){

}

// ラジオボタンで年月日にチェックが入った場合
function date_type0(){
  able_pulldown1();

  //日のプルダウンを活性にする
  pulldown2 = document.getElementById("event_date_3i");
  pulldown2.disabled = false;
}

// ラジオボタンで年月にチェックが入った場合
function date_type1() {
  able_pulldown1();

  //日付を1に設定
  pulldown2_option = document.getElementById("event_date_3i").getElementsByTagName('option');
  pulldown2_option[0].selected = true;

  //日付のプルダウンを非活性にする
  pulldown2 = document.getElementById("event_date_3i");
  pulldown2.disabled = true;
}

// ラジオボタンで年にチェックが入った場合
function date_type2() {
  //月を12に設定
  pulldown1_option = document.getElementById("event_date_2i").getElementsByTagName('option');
  pulldown1_option[11].selected = true;

  //月のプルダウンを非活性にする
  pulldown1 = document.getElementById("event_date_2i");
  pulldown1.disabled = true;

  //日付を31に設定
  pulldown2_option = document.getElementById("event_date_3i").getElementsByTagName('option');
  pulldown2_option[30].selected = true;

  //日付のプルダウンを非活性にする
  pulldown2 = document.getElementById("event_date_3i");
  pulldown2.disabled = true;
}

function able_pulldown1(){
  //月のプルダウンを活性にする
  pulldown1 = document.getElementById("event_date_2i");
  pulldown1.disabled = false;
}
