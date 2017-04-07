class Clientship < ActiveRecord::Base
  belongs_to :business
  belongs_to :user
  has_many :events
  has_many :reviews, through: :events
end
