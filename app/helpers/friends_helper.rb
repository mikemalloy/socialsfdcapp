module FriendsHelper
  
  def load_users
    @neo = Neography::Rest.new(ENV['NEO4J_URL'] || "http://localhost:7474")
    #see if the logged in person is there
    @user = User.find(session[:user_id])
    @graph = Koala::Facebook::API.new(@user.oauth_token)
    me = @graph.get_object("me")
    @me_node = Neography::Node.find("people", "id", me["id"])
    if @me_node.nil? 
      @me_node = Neography::Node.create("id" => me["id"], "name" => me["name"])
      @neo.add_node_to_index("people", "id", @me_node[:id], @me_node)
    end
    
    #iterate over each friend
    @friends = @graph.get_connections("me", "friends")
    
    #if they aren't there, make them and add to the people index
    @friends.each do |friend|
      n1 = Neography::Node.find("people", "id", friend["id"])
      if n1.nil?
        n1 = Neography::Node.create("id" => friend["id"], "name" => friend["name"])
        @neo.add_node_to_index("people", "id", n1[:id], n1)
      end
      rel_nodes = @me_node.both(:friends)
      unless rel_nodes.include? n1
        @me_node.both(:friends) << n1
      end 
    end
  end
  
end
