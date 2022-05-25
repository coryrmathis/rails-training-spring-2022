class NetworksController < ApplicationController

    def index 
        @networks = Network.where(network_params)
        render json: params
    end

    def show
        @network = Network.find(params[:id])

        render json: @network
    end

    def edit 
    end

    def update
    end
    
    def new 
    end

    def create
    end

    def destroy
    end

    private 

    def network_params 
        params.require(:network).permit(
            :name,
            :state
        )
    end

end
