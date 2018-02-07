class EpicenterController < ApplicationController
	before_action :authenticate_user! 

  def following
    @user = User.find(params[:id])

    @users = []

    @user.following.each do |user_id|
      @users.push(User.find(user_id))
    end
 end

  def followers
    @user =User.find(params[:id])

    @users = []

    User.all.each do |user|
      if user.following.include?(@user.id)
        @users.push(user)
      end
    end
  end

 

  def all_users
    @users = User.all
  end

  def tag_tweets
    @tag = Tag.find(params[:id])

  end
  
  def feed
    @tweet = Tweet.new
  	@following_tweets = []

  	Tweet.all.each do |tweet|
  		if (current_user.following.include?(tweet.user_id) || current_user.id == tweet.user_id)
  			@following_tweets.push(tweet)
  		end
  	end
  	@following_tweets.reverse!
  end

  def show_user
  	@user = User.find(params[:id])
    @followers_count = 0

User.all.each do |user|
      if user.following.include?(@user.id)
        @followers_count +=1
      end
    end
    @followers_count
  end
  
  def now_following
  	current_user.following.push(params[:id].to_i)
  	current_user.save

  	redirect_to show_user_path(id: params[:id])


  end

  def unfollow
  	current_user.following.delete(params[:id].to_i)
  	current_user.save

  	redirect_to show_user_path(id: params[:id])
  end
end
