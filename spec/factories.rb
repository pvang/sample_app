# a factory to simulate User model objects.

FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" } 				# name     "Michael Hartl"
    sequence(:email) { |n| "person_#{n}@example.com"}	# email    "michael@example.com"
    password "foobar"									# password "foobar"
    password_confirmation "foobar"						# password_confirmation "foobar"

    factory :admin do # adding a factory for administrative users
      admin true
    end
  end
end