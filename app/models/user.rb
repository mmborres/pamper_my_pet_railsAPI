# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  name            :text
#  dob             :date
#  email           :text
#  password_digest :text
#  admin           :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  has_many :order_items
end
