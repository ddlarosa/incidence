class GroupsController < Controller
  
  map '/groups'

  def initialize
  end

  def index
    @groups=Group.order(:name)
  end

  def new
    render_view :form
  end

  def create_connection id
    @group=Group.find(:id => id); 
    if @group.nil?
      flash[:error] = 'Error al crear la conexion'
      raise "Error al crear la conexion"
      redirect GroupsController.r('index')   
    end
    render_view :connection_form
  end

  def update id
    @group=Group.find(:id => id);
    render_view :edit_form
  end

  def delete id
    @group=Group[:id => id]
   
    error=""
    sucess=""

    begin
      if @group.nil?
        flash[:error] = 'Error al eliminar el Centro'
        raise "Error al eliminar el Centro"
      end

      @group.destroy

      sucess = "Centro eliminado correctamente"
      flash[:success] = sucess
      redirect GroupsController.r('index')

    rescue => e
     Ramaze::Log.error e
     error+="Error al eliminar el centro"
     flash[:error] = "#{error}: #{e}"
     redirect GroupsController.r('index')
    end

  end

  def save
    #Get params
    name=request.params['name']
    phone=request.params['phone']
    description=request.params['description']
    cp=request.params['cp']
    location=request.params['location']
    province=request.params['province']
    region=request.params['region']
    ip=request.params['ip']

    unless name.nil?
      @group=Group.new
      @group.name=name;
      @group.phone=phone;
      @group.description=description
      @group.cp=cp
      @group.location=location
      @group.province=province
      @group.region=region
      @group.ip=ip
      @group.created_at = Time.now
      @group.updated_at = Time.now
       
      begin
      	@group.save
      	#Set flash success message
      	success||="El centro #{@group.name} creado correctamente"
      	flash[:success] = "#{success}"

      rescue => e
        Ramaze::Log.error e
        error||="Error al crear la el centro"
        flash[:error] = "#{error}: #{e}"
        redirect_referrer
      end

    else
      #Set flash error message not name	
      error||="Error Introduzca un nombre"
      flash[:error] = "#{error}"
      redirect_referrer
    end

      redirect GroupsController.r('index') 

   end
  
  def modify
    #Get params
    name=request.params['name']
    phone=request.params['phone']
    description=request.params['description']
    cp=request.params['cp']
    location=request.params['location']
    province=request.params['province']
    region=request.params['region']
    ip=request.params['ip']

    unless name.nil?
      @group=Group.find(:name => name)
      @group.phone=phone;
      @group.description=description
      @group.cp=cp
      @group.location=location
      @group.province=province
      @group.region=region
      @group.ip=ip
      @group.updated_at = Time.now
       
      begin
      	@group.save
      	#Set flash success message
      	success||="El centro #{@group.name} modificado correctamente"
      	flash[:success] = "#{success}"

      rescue => e
        Ramaze::Log.error e
        error||="Error al modificar la el centro"
        flash[:error] = "#{error}: #{e}"
        redirect_referrer
      end

    else
      #Set flash error message not name	
      error||="Error Introduzca un nombre"
      flash[:error] = "#{error}"
      redirect_referrer
    end

      redirect GroupsController.r('index') 

   end

 end