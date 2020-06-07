class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    # @user.image = "default.jpeg"
    if @user.save
      log_in(@user)
      flash[:success] = "アカウントの登録に成功しました"
      redirect_to @user
    else 
      render "new"
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # 成功時
      flash[:success] = "アカウント情報を更新しました"
      redirect_to user_path(@user)
    else
      render "edit"
    end
  end
  
  private
    
    # ストロングパラメーター
    def user_params
      # user属性を必須とし、name,email,password,image属性を許可する
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation, :image)
    end
    
    
    
    # before アクション
    
    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user)
        flash[:danger] = "他者のアカウントは編集できません"
        redirect_to root_url
      end
    end
end
