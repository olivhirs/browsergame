FactoryGirl.define do
  factory :user do
    name     "Olli"
    email    "oliver.hirschmann@gmx.de"
    password "foobar"
    password_confirmation "foobar"
  end
end