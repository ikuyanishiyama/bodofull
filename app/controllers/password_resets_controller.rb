class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  
  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "パスワード再設定用のメールをお送りしました"
      redirect_to root_url
    else
      flash[:danger] = "該当するメールアドレスが見つかりませんでした"
      render "new"
    end
  end
  
  def edit
  end
  
  def update
    # パスワードが空文字の時は、エラーを表示させて再設定画面に戻す
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      render "edit"
    # パスワードの再設定が完了したら、ログインさせてマイページへ
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "パスワードを再設定しました"
      redirect_to @user
    # 無効なパスワードであれば再設定画面に戻す
    else
      render "edit"
    end
  end
  
  private
  
    # ストロングパラメーター(userに関するパラメータを要求し、パスワード関連のみを許可する)
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
  
    # edit.html.erbでhidden_tagで送られたメールアドレスで、ユーザーを取得
    def get_user
      @user = User.find_by(email: params[:email])
    end
    
    # 正しいユーザーがどうか確認する
    def valid_user
      unless (@user && @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end
    
    # トークン（再設定のリンク）が有効切れが確認する
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "リンクの有効期限が切れています"
        redirect_to new_password_reset_url
      end
    end
    
    
end
