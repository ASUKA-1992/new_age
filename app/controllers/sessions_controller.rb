class SessionsController < ApplicationController
  def create
    member = Member.find_by(mail: params[:mail])
    if member&.authenticate(params[:password])
      session[:member_id] = member.id
      session[:member_name] = member.name
      session[:member_admin] = member.admin
      redirect_to :ten_years
    else
      flash.alert = "メールアドレスまたはパスワードが正しくありません"
      render "members/login"
    end
  end

  def destroy
    session.delete(:member_id)
    session.delete(:member_name)
    session.delete(:admin)
    session.delete(:filter_member_id)
    redirect_to :ten_years
  end
end
