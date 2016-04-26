Sequel.migration do
  up do
    alter_table :incidences do
      add_column :review, String 
    end
  end

  down do
    alter_table :incidences do
      drop_column :review
    end
  end

end
