class FcmPush

  require 'fcm'

  def initialize
    @fcm = FCM.new(Rails.application.secrets.fcm_token)
  end

  def send_push_notification(title="Profiler", body="Profiler", reg_ids=[])
    options = {
      "notification": {
      "title": title,
      "body": body
      },
      priority: 'high',
    }
    response = @fcm.send(reg_ids, options)
  end

  def send_daily_push
    q= Question.question_of_day
    if q.present? && UserDevice.active.present?
      # UserDevice.active.each do |device|
      #   token = []
      #   token.push(device.push_token)
      #   send_push_notification('Question of the day', q.question_text, token)
      # end
      send_push_notification('Question of the day', q.question_text, UserDevice.active.pluck(:push_token))
    end
  end

end