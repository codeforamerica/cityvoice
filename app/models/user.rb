# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  login      :string(255)
#  created_at :datetime
#  updated_at :datetime
#



class User < ActiveRecord::Base

	  # users.password_hash in the database is a :string
 

    #VALID_INPUTS = /[[:ascii:]]+/
    #validates :name, presence: true, length: { maximum: 128 },
        #format: { with: VALID_INPUTS }, uniqueness: true
    has_secure_password
    validates :email, presence: true
    validates :id, presence: true



end