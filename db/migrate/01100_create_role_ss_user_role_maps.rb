class CreateRoleSsUserRoleMaps < ActiveRecord::Migration
  def change
    create_table :role_ss_user_role_maps do |t|
      t.integer :entity_ss_user_id, null: false
      t.integer :entity_ss_role_id, null: false
      t.timestamps null: false

      t.index [:entity_ss_user_id, :entity_ss_role_id], unique: true, name: 'role_ss_user_map_user_id_role_id_uniqueness'
    end
  end
end