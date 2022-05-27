class NetworkCountChannel < ApplicationCable::Channel
  def subscribed
    stream_from "networks_count_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
