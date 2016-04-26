Sequel.migration do
  up do
    alter_table :motives do
      add_column :model, String 
    end
  end

  down do
    alter_table :motives do
      drop_column :model
    end
  end

end
