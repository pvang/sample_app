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

  factory :micropost do # adding a factory for microposts
    content "Lorem ipsum" # we tell Factory Girl about the micropost’s associated user by including a user in the definition of the factory
    user
  end
end