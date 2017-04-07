class Clientship < ActiveRecord::Base
  belongs_to :business
  belongs_to :user
end
