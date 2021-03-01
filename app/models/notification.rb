# == Schema Information
#
# Table name: notifications
#
#  id                :bigint           not null, primary key
#  description       :string
#  notification_type :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  notifier_id       :integer
#  object_id         :integer
#  user_id           :bigint
#
# Indexes
#
#  index_notifications_on_user_id  (user_id)
#

class Notification < ApplicationRecord
  belongs_to :user

  def self.import_record(ids,event)
    testArr = []
    ids.each do |user_id|
      testArr << {
                    user_id: user_id,
                    description: "#{event.owner.first_name} post upcoming event",
                    notification_type: "event_create",
                    notifier_id: event.owner_id,
                    object_id: event.id
                  }
    end
    Notification.import testArr
  end

  def self.import_update(ids,event)
    testArr = []
    ids.each do |user_id|
      testArr << {
                    user_id: user_id,
                    description: "#{event.owner.first_name} changed details for an event",
                    notification_type: "event_change",
                    notifier_id: event.owner_id,
                    object_id: event.id
                  }
    end
    Notification.import testArr
  end

end
