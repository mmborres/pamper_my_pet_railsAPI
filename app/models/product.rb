# == Schema Information
#
# Table name: products
#
#  id             :bigint(8)        not null, primary key
#  name           :text
#  image          :text
#  description    :text
#  size           :text
#  color          :text
#  price          :integer
#  stock          :integer
#  classification :text
#  pet_type       :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Product < ApplicationRecord
end
