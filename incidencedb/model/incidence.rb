
class Incidence < Sequel::Model(:incidences)
  
  plugin :association_dependencies
  
  many_to_one :motive

end
