# 001_initial.rb                                          -*- coding: utf-8 -*-

Sequel.migration do
  up do
    create_table(:groups) do
      primary_key :id
      String :name, {null: false, unique: true}
      check{char_length(name) > 0}
      String :phone
      String :description
      String :address
      String :cp
      String :location
      String :province
      String :region
      Time   :created_at, null:false
      Time   :updated_at, null:false
    end
   
    create_table(:connections) do 
      primary_key :id
      String :manager
      String :description
      TrueClass :revision_cabling
      TrueClass :sending_cabling
      Time   :created_at, null:false
      Time   :updated_at, null:false
      foreign_key :group_id, :groups
    end

  end

  down do
    drop_table :groups
    drop_table :connections
  end
end
