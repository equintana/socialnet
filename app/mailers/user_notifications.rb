class UserNotifications < ActionMailer::Base
  default from: "no-replay@socialnet.com"

  def friend_request_notification(user, sender)
  	@user = user
  	@sender = sender
  	mail(:to => user.email, :subject => "You have a new friend request")
  end

  def accepted_friend(user, sender)
  	@user = user
  	@sender = sender
  	mail(:to => sender.email, :subject => "#{user.name.capitalize} has accepted your friend request")
  end
end
