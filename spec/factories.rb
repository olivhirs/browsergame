FactoryGirl.define do
  factory :user do
    name     "Olli"
    email    "oliver.hirschmann@gmx.de"
    password "foobar"
    password_confirmation "foobar"
    password_reset_token "blubb_blubb"
    password_reset_sent_at Time.now
    email_confirmation_token "blubb_blubb2"
    email_confirmation true
  end
end