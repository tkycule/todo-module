class Task < ActiveRecord::Base

  include AASM

  belongs_to :user

  validates :user_id, presence: true
  validates :title, presence: true

  aasm do
    state :inbox, initial: true
    state :completed
    state :deleted

    event :complete do
      transitions to: :completed
    end

    event :delete do
      transitions to: :deleted
    end

    event :revert do
      transitions to: :inbox
    end
  end
  
end
