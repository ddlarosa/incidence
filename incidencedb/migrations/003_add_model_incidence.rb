Sequel.migration do
  up do
    alter_table :incidences do
      add_column :model, String 
    end
  end

  down do
    alter_table :incidences do
      drop_column :model
    end
  end

end
