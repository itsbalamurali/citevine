class NotificationsMailer < ActionMailer::Base

  default :from => "citivine@gmail.com"
  default :to => "g.raoult@gmail.com"

  def new_message(message)
    @message = message
    mail(:subject => "[Citivine.com] #{message.email}")
  end

end