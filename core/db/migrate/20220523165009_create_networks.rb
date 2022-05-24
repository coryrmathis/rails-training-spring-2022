class CreateNetworks < ActiveRecord::Migration[6.1]
  def change
    create_table :networks, id: :uuid do |t|
      t.string :name
      t.string :network_type
      t.string :state

      t.timestamps
    end
  end

end
