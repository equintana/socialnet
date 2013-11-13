# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tweet do
    tweet "Esto es un tweet de 140 caracteres"
    association :user
  end

  factory :tweet_with_image, parent: :tweet do | t |
    t.image Rack::Test::UploadedFile.new(Rails.root.join("spec/factories/files/avatar.jpg"))
  end

  factory :tweet_with_pdf, parent: :tweet do | t |
  	t.image Rack::Test::UploadedFile.new(Rails.root.join("spec/factories/files/avatar.pdf"))
  end
end
