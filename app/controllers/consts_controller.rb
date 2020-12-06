class ConstsController < ApplicationController
  before_action :login_required

  def index
    #ConstTBLに登録されている総人口取得
    @total_population = Const.find_by(key: "TOTAL_POPULATION")

    # ageTBLに登録されている値取得
    @age_and_genders = Age.order("id").first

    # prefecturTBLに登録されている値取得
    @prefectures = Prefecture.order("id").first
  end

  def new
    #adminでない場合、indexにリダイレクト
    if !session[:member_admin]
      redirect_to action: 'index'
      return
    end

    @total_population = Const.new()
    @total_population.value = 0
  end

  def create
    @total_population = Const.new(const_params)
    @total_population.key = "TOTAL_POPULATION"

    # 0の場合は登録を実施しない。文字列が入力された場合もここで引っかかる
    if @total_population.value == 0
      render 'new'
      return
    end

    if @total_population.save
      redirect_to action: 'index'
    else
      render 'new'
    end
  end

  def destroy
    con = ActiveRecord::Base.connection

    # 総人口、年齢男女別人口、都道府県別人口を削除
    con.execute("DELETE FROM consts WHERE key = \"TOTAL_POPULATION\"")
    con.execute("DELETE FROM ages")
    con.execute("DELETE FROM prefectures")

    #新規作成画面へリダイレクト
    redirect_to action: 'new', key: "TOTAL_POPULATION"
  end

  private def const_params
    attrs = [
      :value
    ]
    params.require(:const).permit(attrs)
  end

end
