class ConnectionsController < Controller
  map '/connections'

  def initialize
  end

  def index
    @connections=Connection.reverse_order(:created_at)
  end
   
  def delete connection_id 

    @connection=Connection[:id => connection_id]
   
    error=""
    sucess=""

    begin

      if @connection.nil?
        flash[:error] = 'Error al eliminar la conexion'
        raise "Error al eliminar la conexion"
      end

      @connection.destroy

      sucess = "Conexion eliminada correctamente"
      flash[:success] = sucess
      redirect ConnectionsController.r(nil)

    rescue => e
     Ramaze::Log.error e
     error+="Error al crear la conexion"
     flash[:error] = "#{error}: #{e}"
     redirect ConnectionsController.r(nil)
    end
 
 
    redirect ConnectionsController.r(nil)
  end
  
  def edit connection_id 
   @connection=Connection[:id => connection_id]
   @group=@connection.group
   render_view :edit_form
  end

  def modify_connection  

    @connection=Connection[:id => request.params['id']]
    manager=request.params['manager']
    description = request.params['description']
    revision_cabling = request.params['revision_cabling']
    sending_cabling = request.params['sending_cabling']

    error=""
    success=""

    begin

      if @connection.nil? 
        flash[:error] = 'Necesitamos el nombre del centro'
        raise "Necesitamos el nombre de la incidencia"
      end

      if revision_cabling.nil? or revision_cabling.empty?
         @connection.revision_cabling=false
      else
         @connection.revision_cabling=true
      end

      if sending_cabling.nil? or sending_cabling.empty?
         @connection.sending_cabling=false
      else
         @connection.sending_cabling=true
      end
     
      @connection.manager=manager
      @connection.description=description

      @connection.save

      success="Conexion modificada correctamente para el centro #{@connection.group[:name]}"
      flash[:success] = success
      redirect ConnectionsController.r(nil)

    rescue => e
      Ramaze::Log.error e
      error+="Error al crear la conexion"
      flash[:error] = "#{error}: #{e}"
    end
  end
  
  def new
    @groups = Group.order(:name)
    render_view :form
  end
 
  def save
    group_name=request.params['name']
    manager=request.params['manager']
    description = request.params['description']
    revision_cabling = request.params['revision_cabling']
    sending_cabling = request.params['sending_cabling']

    error=""
    success=""
 
    begin

      if group_name.nil? or group_name.empty?
        flash[:error] = 'Necesitamos el nombre del centro'
        raise "Necesitamos el nombre de la incidencia"
      end

      if revision_cabling.nil? or revision_cabling.empty?
         revision_cabling=false
      else
         revision_cabling=true
      end
    
      if sending_cabling.nil? or sending_cabling.empty?
         sending_cabling=false
      else
         sending_cabling=true
      end

      group=Group.first(:name => group_name)
      connection=Connection.new
      connection.group_id=group.id
      connection.manager=manager 
      connection.description=description
      connection.revision_cabling=revision_cabling
      connection.sending_cabling=sending_cabling
      connection.created_at = Time.now
      connection.updated_at = Time.now
      connection.save
     
      success="Conexion guardada correctamente para el centro #{group_name}"
      flash[:success] = success
      redirect ConnectionsController.r(nil)

    rescue => e
      Ramaze::Log.error e
      error+="Error al crear la conexion"
      flash[:error] = "#{error}: #{e}"
    end
 end
 
 def show_revision_template connection_id
   
   @connection=Connection[:id=>connection_id]
   
 end

 def send_revision_cabling 

   #Get params
   musicam_worker=request.params['musicam_worker']
   connection_id=request.params['connection_id']
   @connection=Connection[:id => connection_id]
   branch=@connection.group.name
   manager=@connection.manager
   error=""

   begin

     if @connection.nil?
       flash[:error] = 'Error al enviar la revision de cableado'
       raise "Error al enviar la revision de cableado"
     end
      
     success="Revision de cableado para el centro #{branch} enviada correctamete"

     rescue => e
       Ramaze::Log.error e
       error+="Error al crear la inicidencia"
       flash[:error] = "#{error}: #{e}"
       redirect_referrer
    end

    begin   

      @email=MusicamEmailConnection.new(EMAIL_CONFIG_CONNECTION)
        
      @email.clean_smtp_cache
      @email.send_ack(@connection,musicam_worker) 
         
    rescue => e
      Ramaze::Log.error e
      error+="La revision de cabledo no ha podido enviarse"
      flash[:error] = "#{error}: #{e}"
      flash[:success] = success
      redirect_referrer
    end     

      flash[:success] = success
      redirect ConnectionsController.r(nil)

 end
 
end