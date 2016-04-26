
class Motive < Sequel::Model(:motives)

  plugin :association_dependencies

  one_to_many :incidences

end
