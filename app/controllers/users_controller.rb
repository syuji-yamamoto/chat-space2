class UsersController < ApplicationController
  def index
    return nil if params[:keyword] == ""
    @users = User.where('name LIKE(?) and id NOT IN (?)', "%#{params[:keyword]}%", excluded_users)
    respond_to do |format|
      format.html
      format.json
    end
  end

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end

  def excluded_users
    excluded_users = []
    excluded_users << current_user.id
    if params[:selected_users]
      params[:selected_users].map do |user_id|
        excluded_users << user_id
      end
    end
    return excluded_users
  end
end
