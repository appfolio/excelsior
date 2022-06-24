FactoryBot.define do
  sequence :email do |n|
    "jon#{n}@alloweddomain.com"
  end

  sequence :first_name do |n|
    "John#{n}"
  end

  factory :user, :aliases => [:submitter, :recipient] do
    first_name
    last_name {'Doe'}
    email
    password {'f4k3p455w0rd'}

    factory :admin do
      admin {true}
    end
  end

  factory :appreciation, aliases: [:message] do
    message {'I appreciate when a rails upgrade works smoothly'}
    association :recipient
    association :submitter
  end
end
