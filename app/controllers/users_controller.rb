class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      flash[:success] = "アカウントの登録に成功しました"
      redirect_to @user
    else 
      render "new"
    end
  end
  
  private
    
    # ストロングパラメーター
    def user_params
      # user属性を必須とし、name,email,password属性を許可する
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
