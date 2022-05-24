class Network < ApplicationRecord
    before_create do 
        self.state = self.state.chomp
    end
    
    validates :state, inclusion: {in: ['active', 'inactive']}

end
