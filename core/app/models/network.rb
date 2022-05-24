class Network < ApplicationRecord
    has_many :memberships 
    has_many :providers, through: :memberships 

    
    scope :active, -> { where(state: 'active')}
    validates :state, inclusion: {in: ['active', 'inactive']}

end
