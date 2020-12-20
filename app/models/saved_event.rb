# == Schema Information
#
# Table name: saved_events
#
#  id            :bigint           not null, primary key
#  saveable_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  saveable_id   :integer
#  user_id       :integer
#

class SavedEvent < ApplicationRecord

  ############ Associations ##############

  belongs_to :user
  # belongs_to :my_saved_event, foreign_key: 'event_id', class_name: 'Event'
  belongs_to :saveable, polymorphic: true

  ############ Scopes ##############

  ############ Validations ##############

  validates :user_id, presence: true

end
