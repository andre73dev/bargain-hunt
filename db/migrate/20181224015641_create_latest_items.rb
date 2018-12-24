class CreateLatestItems < ActiveRecord::Migration
  def change
    create_table :latest_items do |t|
      t.string :asin
      t.string :title
      t.string :small_image
      t.string :medium_image
      t.string :large_image
      t.decimal :ofr_amount
      t.decimal :val_amount
      t.integer :sales_rank
      t.string :condition
      t.string :availability
      t.string :detail_page_url
      t.datetime :release_date
      t.string :all_offers_url
      t.string :search_index
      t.string :browse_node
      t.string :browse_nodename

      t.timestamps null: false
    end
  end
end
