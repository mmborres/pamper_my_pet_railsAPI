# == Schema Information
#
# Table name: users
#
#  id                   :bigint(8)        not null, primary key
#  name                 :text
#  dob                  :date
#  email                :text
#  password_digest      :text
#  admin                :boolean
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  confirmation_token   :text
#  confirmed_at         :datetime
#  confirmation_sent_at :datetime
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
