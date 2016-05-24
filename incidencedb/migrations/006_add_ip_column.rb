Sequel.migration do
  up do
    alter_table :groups do
      add_column :ip, String 
    end
  end

  down do
    alter_table :groups do
      drop_column :i
    end
  end
end