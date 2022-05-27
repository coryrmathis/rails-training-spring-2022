class NetworksController < ApplicationController

    def index 
        @networks = Network.all.page(params[:page]).per(10)
    end

    def show
        @network = Network.find(params[:id])
    end

    def new 
        @network = Network.new
    end

    def create
        @network = Network.new(network_params)

        if @network.save 
            redirect_to @network
        else
            flash[:network_errors] = @network.errors.full_messages.join(", ")
            render :new
        end
    end

    def edit 
        @network = Network.find(params[:id])
    end

    def update
        @network = Network.find(params[:id])

        if @network.update(network_params)
            redirect_to @network
        else
            flash[:network_errors] = @network.errors.full_messages.join(", ")
            render :new
        end
    end

    def destroy
        @network = Network.find(params[:id])

        if @network.destroy 
            redirect_to networks_path
        end
    end

    def export
        NetworksExportJob.perform_async(Network.first.id) 
        redirect_to "/networks"
    end

    private 

    def network_params 
        params.require(:network).permit(
            :name,
            :state
        )
    end

end
