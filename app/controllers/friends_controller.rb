class FriendsController < ApplicationController
  def index
    load_users
    @friend_list = @me_node.outgoing(:friends)
  end
  
  def show
    fb_id = params[:id]
    if @graph.nil?
      @user = User.find(session[:user_id])
      @graph = Koala::Facebook::API.new(@user.oauth_token)
    end
    @friend = @graph.get_object(fb_id)
    @picture = @graph.get_picture(fb_id)
    @likes = @graph.get_connections(fb_id, "likes")
  end
  
  
end
