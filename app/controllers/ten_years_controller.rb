class TenYearsController < ApplicationController

  def index
    #読み込みCSV取得
    if params[:csv] != nil
      #パラメーターにcsvファイル名がついている場合
      if params[:csv] == "default.csv"
        #デフォルトデータが選択された場合
        target_csv = "default.csv"
      else
        #パラメーターにmember_idがついている場合
        if params[:member_id] != nil
          target_csv = params[:member_id].to_s + "_member/" + params[:csv]
        else
          #ついてない場合
          target_csv = session[:member_id].to_s + "_member/" + params[:csv]
        end
      end
    elsif session[:member_id] != nil
      #メインボタン押下の場合
      target_csv = session[:member_id].to_s + "_member/target.csv"
    else
      #ログインしていない場合
      target_csv = "default.csv"
    end

    #CSV読み込み
    require "csv"
    @data_arr = CSV.read(Rails.root.join('app', 'csv', target_csv))
    #1番上の行はヘッダだから削除
    @data_arr.delete_at(0)
  end

  def detail
  end

end
