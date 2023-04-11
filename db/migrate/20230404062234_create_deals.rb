class CreateDeals < ActiveRecord::Migration[7.0]
  def change
    create_table :deals do |t|
      t.string :company
      t.bigint :kylas_entity_id
      t.string :name
      t.integer :status, default: 0
      t.boolean :has_shown, default: false
      t.timestamps
      t.references :tenant, null: false, foreign_key: true
    end
  end
end

