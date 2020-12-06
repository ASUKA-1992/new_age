class ApplicationController < ActionController::Base
  private def current_member
    Member.find_by(id: session[:member_id]) if session[:member_id]
  end
  helper_method :current_member

  class LoginRequired < StandardError; end

  private def login_required
    #例外処理
    path = request.fullpath
    #メンバー新規登録画面への遷移
    if path.end_with?("members/new")
      return
    end

    raise LoginRequired unless current_member
  end

  rescue_from LoginRequired, with: :rescue_login_required

  private def rescue_login_required(exception)
    render "/members/login"
  end

end
