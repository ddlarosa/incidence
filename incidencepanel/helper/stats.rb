module Ramaze
  module Helper
    module Stats 
      def get_month num_month
        case num_month 
         when '01' 
           "Enero"
         when '02'
           "Febrero"
         when '03'
           "Marzo"
         when '04'
           "Abril"
         when '05'
           "Mayo"
         when '06'
           "Junio"
         when '07'
           "Julio"
         when '08'
           "Agosto"
         when '09'
           "Septiembre"
         when '10'
           "Octubre"
         when '11'
           "Noviembre"
         when '12'
           "Diciembre"
         else
           "Otro"
         end 
      end
    end

    def get_arr_avg_time avg_time

      avg_time_year=Hash.new

      avg_time.each do |key,value| 
        avg_time_year[key[:year]] = key[:avg_time] 
      end
      
      return avg_time_year 
    end

  end
end

