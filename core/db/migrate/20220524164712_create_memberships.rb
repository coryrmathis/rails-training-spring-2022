class CreateMemberships < ActiveRecord::Migration[6.1]
  def change
    create_table :memberships do |t|
      t.uuid :network_id
      t.uuid :provider_id

      t.timestamps
    end
  end
end
