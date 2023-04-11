class CreateTenants < ActiveRecord::Migration[7.0]
  def change
    create_table :tenants do |t|
      t.bigint :kylas_tenant_id
      t.string :email
      t.integer :tenant_type, default: 1
      t.timestamps
    end
  end
end 

