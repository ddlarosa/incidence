
class Connection < Sequel::Model(:connections)

  plugin :association_dependencies

  many_to_one :group

end
