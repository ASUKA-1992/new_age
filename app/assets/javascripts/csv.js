window.onload = function() {
  document.getElementById("include_fiction_true").checked = true;
}

function set_delete_file(){
  //選択されているファイル名取得
  var element = document.getElementById("csv") ;
  var file_name = element.value ;

  //ファイル名が空白の場合、確定ボタン非表示
  if(file_name == ''){
    $("#csv_decide_btn").addClass("div_display_none");
    $("#update_default").addClass("div_display_none");

    //データ表示ボタンも同様
    $("#show_data_form").addClass("div_display_none");

  } else if (file_name == 'default.csv') {
    // 初期データの場合はメイン設定ボタン非表示
    $("#csv_decide_btn").addClass("div_display_none");
    $("#update_default").addClass("div_display_none");
    $("#show_data_form").removeClass("div_display_none");

  } else {
    $("#csv_decide_btn").removeClass("div_display_none");
    $("#update_default").removeClass("div_display_none");

    //データ表示ボタンも同様
    $("#show_data_form").removeClass("div_display_none");
  }

  //input欄にファイル名を入れる
  $("#show_file").val(file_name);
  $("#delete_file").val(file_name);

  // 削除ボタン表示非表示判定
  var current_csv = $("#current_csv").text() + ".csv";
  if(current_csv == file_name || "" == file_name || "default.csv" == file_name){
    $("#delete_file_form").addClass("div_display_none");
  } else {
    $("#delete_file_form").removeClass("div_display_none");
  }
}
