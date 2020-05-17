class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # 成功時
      log_in(user)
      redirect_to user
    else
      # 失敗時
      flash.now[:danger] = "メールアドレスかパスワードが間違っています"
      render "new"
    end
  end
  
  def destroy
    log_out
    redirect_to root_url
  end
end
