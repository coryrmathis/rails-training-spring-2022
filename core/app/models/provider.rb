class Provider < ApplicationRecord
    has_many :memberships
    has_many :networks, through: :memberships

end
