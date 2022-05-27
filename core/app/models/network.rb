class Network < ApplicationRecord
    paginates_per 10
    after_create :broadcast_count

    has_many :memberships 
    has_many :providers, through: :memberships 

    
    scope :active, -> { where(state: 'active')}
    validates :state, inclusion: {in: ['active', 'inactive']}

    def broadcast_count
        puts "BROADCAST CODE"
        NetworkCountChannel.broadcast_to(User.first, {"hello": "world"})
    end

end
