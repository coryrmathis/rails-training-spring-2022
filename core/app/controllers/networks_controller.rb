class NetworksController < ApplicationController

    def show
        @network = Network.find(params[:id])
    end
end
