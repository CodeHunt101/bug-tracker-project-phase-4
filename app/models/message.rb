class Message < ApplicationRecord
  # binding.pry
<<<<<<< HEAD
  belongs_to :sender, class_name: "User", foreign_key: :sender_id
  belongs_to :recipient, class_name: "User", foreign_key: :recipient_id
=======
  # belongs_to :sender, class_name: "User", foreign_key: :sender_id
  # belongs_to :recipient, class_name: "User", foreign_key: :recipient_id
>>>>>>> master
end