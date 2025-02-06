# To deliver this notification:
#
# InviteReceivedNotifier.with(record: @post, message: "New post").deliver(User.all)

class InviteReceivedNotifier < ApplicationNotifier
  deliver_by :action_cable do |c|
    c.params = ->(recipient) { { user: recipient } }
    c.message = 'abo'
  end
  def message
    "#{params[:inviter].username} has sent you an invitation to #{params[:room].name}."
  end
  notification_methods do
    def message
      "#{params[:inviter].username} has sent you an invitation to #{params[:room].name}."
    end
  end
  # deliver_by :email do |config|
  #   config.mailer = "UserMailer"
  #   config.method = "new_post"
  # end
  #
  # bulk_deliver_by :slack do |config|
  #   config.url = -> { Rails.application.credentials.slack_webhook_url }
  # end
  #
  # deliver_by :custom do |config|
  #   config.class = "MyDeliveryMethod"
  # end

  # Add required params
  #
  # required_param :message
end
