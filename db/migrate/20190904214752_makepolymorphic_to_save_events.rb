class MakepolymorphicToSaveEvents < ActiveRecord::Migration[5.2]
  def up
    rename_column :saved_events, :event_id, :saveable_id
    add_column :saved_events, :saveable_type, :string
  end

  def down
    rename_column :saved_events, :saveable_id
    remove_column :saved_events, :saveable_type, :string
  end

end
