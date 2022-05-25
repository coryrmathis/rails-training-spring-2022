class NetworkPolicy < ApplicationPolicy 

    def show?
        if user.admin
            true
        else
            false
        end
    end
end