class CreateProviders < ActiveRecord::Migration[6.1]
  def change
    create_table :providers, id: :uuid do |t|
      t.boolean "licensed", default: false, null: false
      t.text "name", null: false
      t.text "description"
      t.text "website_url"
      t.text "logo_url"
      
      t.timestamps
    end
  end
end
