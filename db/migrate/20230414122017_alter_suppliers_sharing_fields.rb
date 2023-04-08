class AlterSuppliersSharingFields < ActiveRecord::Migration[5.2]
  def up
    change_table :suppliers do |t|
      # TODO:
      # t.remove :shared_supplier_id
      t.column :supplier_remote_source, :string
    end
  end

  def down
    change_table :suppliers do |t|
      # TODO:
      # t.remove :shared_supplier_id, :integer
      t.remove :supplier_remote_source
    end
  end
end
