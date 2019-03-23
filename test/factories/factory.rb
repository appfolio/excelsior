FactoryBot.define do
  sequence :email do |n|
    "jon#{n}@alloweddomain.com"
  end

  sequence :first_name do |n|
    "John#{n}"
  end

  factory :user, :aliases => [:submitter, :recipient] do
    first_name
    last_name  "Doe"
    email
    password 'f4k3p455w0rd'

    factory :admin do
      admin true
    end
  end

  factory :appreciation, aliases: [:message] do
    message 'I appreciate when a rails upgrade works smoothly'
    association :recipient
    association :submitter
  end

  factory :feedback, :aliases => [:root] do
    message 'You could take a little more pride in your code. Seriously, copy and pasting everything between Appreciations and Feedbacks?'
    association :recipient
    association :submitter
  end

  factory :comment do
    message 'I do not think that feedback was very clear'
    association :recipient
    association :submitter
    association :root
  end

  factory :like do
    association :message
    association :user
  end

end
