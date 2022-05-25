class NetworksController < ApplicationController
    include Pundit::Authorization
    
    def index 
        @networks = Network.all
        render json: current_usere
    end

    def show
        @network = Network.find(params[:id])
        authorize @network
    end

    def edit 
        @network = Network.find(params[:id])
    end

    def update
        @network = Network.find(params[:id])

        if @network.update
            redirect_to @network
        else
            render json: @network.errors.full_messages
        end
    end
    
    def new 
        @network = Network.new
    end

    def create
        @network = Network.new(network_params)

        if @network.save 
            redirect_to @network
        else
            render json: @network.errors.full_messages
        end
    end

    def destroy
        @network = Network.find(params[:id])

        if @network.destroy 
            redirect_to :index
        end
    end

    private 

    def network_params 
        params.require(:network).permit(
            :name,
            :state
        )
    end

end
