json.extract! product, :id, :name, :image, :description, :size, :color, :price, :stock, :classification, :pet_type, :created_at, :updated_at
json.url product_url(product, format: :json)
