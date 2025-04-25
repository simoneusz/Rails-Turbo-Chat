FactoryBot.define do
  factory :jwt_denylist do
    jti { "MyString" }
    exp { "2025-04-24 16:06:14" }
  end
end
