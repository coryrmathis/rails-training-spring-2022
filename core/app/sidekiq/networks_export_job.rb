class NetworksExportJob
  include Sidekiq::Job

  def perform(network_id)
    puts "IN THE JOB*************"
    network = Network.find(network_id)
    File.open(Rails.root.join("tmp", "network_ids.csv"), "w+") do |f|
        puts network.id + "**********"
        f.write("#{network.id},#{network.name}\n")
    end
  end
end
