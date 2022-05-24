class Membership < ApplicationRecord
    belongs_to :network 
    belongs_to :provider

end
