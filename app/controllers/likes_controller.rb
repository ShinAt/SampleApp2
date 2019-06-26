class LikesController < ApplicationController
  before_action :logged_in_user
  
  def create
    @micropost = Micropost.find(params[:micropost_id])
      if @micropost.user_id != current_user.id
        unless @micropost.like?(current_user)
          @micropost.like(current_user)
          @micropost.reload
          
        end
      end
      
      respond_to do |format|
        format.html { redirect_to request.referrer || root_url }
        format.js
      end
  end

  def destroy
    @micropost = Like.find(params[:id]).micropost
    if @micropost.user_id != current_user.id
      if @micropost.like?(current_user)  
        @micropost.unlike(current_user)
        @micropost.reload
      end
    end
    
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
    
  end
end
