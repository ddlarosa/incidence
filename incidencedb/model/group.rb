
class Group < Sequel::Model(:groups)

  plugin :association_dependencies

  one_to_many :connections

end
