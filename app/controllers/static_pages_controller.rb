class StaticPagesController < ApplicationController
  def home
    @micropost = current_user.microposts.build if logged_in?
    @microposts = Micropost.all.paginate(page: params[:page])
  end

  def about
  end
end
