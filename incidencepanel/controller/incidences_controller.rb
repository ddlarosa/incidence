class IncidencesController < Controller
  helper :stats 
  map '/incidences'

  def initialize
  end

  def index
   redirect IncidencesController.r('login') unless session[:logged_in] 
   @title = 'Incidencias Pendientes'
   @incidences=Incidence.where(:motive_id => [1, 2]).order(:created_at)
  end

  def login
     if request.post?
      username=request.params['username']
      password=request.params['password']
      
      if username=="tecnicamercadona" && password=="1_sdfci?"
        session[:logged_in]=true
        redirect IncidencesController.r(nil)
      else
        flash[:error]='Invalid user and password'
        redirect_referrer
      end
    end
  end

  def stats 

    @model=request.params['model']

    #Stats per year    
    @stats = DB.fetch("SELECT to_char(created_at, 'yyyy') AS year, count(*) AS number  
FROM incidences  WHERE model=? group by to_char(created_at, 'yyyy') ORDER BY to_char(created_at, 'yyyy')", model).all
    
    #Avg Time per Incidence group by years
    @avg_time = DB.fetch("SELECT to_char(created_at, 'yyyy') AS year,to_char(avg(solution_date - created_at),'dd hh:mm:ss') AS avg_time FROM incidences WHERE model=? GROUP BY to_char(created_at, 'yyyy') ORDER BY to_char(created_at, 'yyyy')",model).all

    @avg_time_incidence=get_arr_avg_time @avg_time

end

  def rm6_stats
    #Query the rm6 incidences group by month    
    @stats = DB.fetch("SELECT to_char(created_at, 'yyyy') AS year, count(*) AS number  
FROM incidences  WHERE model='RM6' group by to_char(created_at, 'yyyy') ORDER BY to_char(created_at, 'yyyy')").all

   @avg_time = DB.fetch("SELECT to_char(created_at, 'yyyy') AS year,to_char(avg(solution_date - created_at),'dd hh:mm:ss') AS avg_time FROM incidences WHERE model='RM6' GROUP BY to_char(created_at, 'yyyy') ORDER BY to_char(created_at, 'yyyy')").all

   @avg_time_incidence=get_arr_avg_time @avg_time

  end 

  def rm6_stats_month

    @model=request.params['model']
    @year=request.params['year']

    #Query the rm6 incidences group by month    
    @stats = DB.fetch("SELECT to_char(created_at, 'mm') AS month, count(*) AS number  
FROM incidences WHERE model=? AND to_char(created_at, 'yyyy') = ?  group by to_char(created_at, 'yyyy'), to_char(created_at, 'mm') ORDER BY to_char(created_at, 'yyyy'), to_char(created_at, 'mm')",@model,@year).all

  end


  def rm8_stats
    #Query the rm8 incidences group by month    
    @stats = DB.fetch("SELECT to_char(created_at, 'yyyy') AS year, count(*) AS number  
FROM incidences  WHERE model='RM8' group by to_char(created_at, 'yyyy') ORDER BY to_char(created_at, 'yyyy')").all

     @avg_time = DB.fetch("SELECT to_char(created_at, 'yyyy') AS year,to_char(avg(solution_date - created_at),'dd hh:mm:ss') AS avg_time FROM incidences WHERE model='RM8' GROUP BY to_char(created_at, 'yyyy') ORDER BY to_char(created_at, 'yyyy')").all

    @avg_time_incidence=get_arr_avg_time @avg_time

  end

 def rm8_stats_month

    @model=request.params['model']
    @year=request.params['year']

    #Query the rm6 incidences group by month    
    @stats = DB.fetch("SELECT to_char(created_at, 'mm') AS month, count(*) AS number  
FROM incidences WHERE model=? AND to_char(created_at, 'yyyy') = ?  group by to_char(created_at, 'yyyy'), to_char(created_at, 'mm') ORDER BY to_char(created_at, 'yyyy'), to_char(created_at, 'mm')",@model,@year).all

  end

  def index_solution
   redirect IncidencesController.r('login') unless session[:logged_in]
   @title = 'Incidencias Resueltas'
   @model = request.params['model'] 

   if @model
    @incidences=Incidence.where(:motive_id => [3],:model=>@model).reverse_order(:id)
   else
    @incidences=Incidence.where(:motive_id => [3]).reverse_order(:id)
   end

  end
  
  def new
    redirect IncidencesController.r('login') unless session[:logged_in]
    render_view :form
  end

  def edit task_id
   redirect IncidencesController.r('login') unless session[:logged_in] 
   @motives=Motive
   @incidence=Incidence[task_id]    
   render_view :edit_form
  end

  def modify_incidence
    redirect IncidencesController.r('login') unless session[:logged_in]
    task_id=request.params['task_id']
    @incidence=Incidence[task_id] 

    error=""
    success="" 
    
    begin
    
      if @incidence.nil?
        flash[:error] = 'Error al guardar la incidencia'
        raise "Error al guardar la incidencia"
      end

      send_email=request.params['send_email'].to_i
      
      @incidence.name = request.params['name']
      @incidence.model = request.params['model']
      @incidence.task_create_from=request.params['task_created_from']
      @incidence.branch_tiz=request.params['branch_tiz']
      @incidence.phone_tiz=request.params['phone_tiz'] 
      @incidence.branch=request.params['branch']
      @incidence.location=request.params['location']
      @incidence.address=request.params['address']
      @incidence.name_of_claimant=request.params['name_of_claimant']
      @incidence.phone_of_claimant=request.params['phone_of_claimant']
      @incidence.problem=request.params['problem']
      @incidence.problem_description=request.params['problem_description']
      @incidence.pending=request.params['pending']
      @incidence.solution=request.params['solution']
      @incidence.review=request.params['review']
      @incidence.motive_id=request.params['motive_id'].to_i
      @incidence.modified_at=Time.now
      @incidence.save
      
      success="Incidencia #{@incidence.name} modificada correctamente"

      rescue => e
        Ramaze::Log.error e
        error+="Error al crear la inicidencia"
        flash[:error] = "#{error}: #{e}"
        redirect_referrer
      end

      begin   

      if send_email ==1
         @email=MusicamEmail.new(EMAIL_CONFIG)
         @email.clean_smtp_cache
         
         case @incidence.motive_id 

         when 1
          @email.send_ack @incidence
          @incidence.sended_ack=true
          @incidence.acknowledgment_date=Time.now
          @incidence.save
          success+="<br/>Acuse de recibo se ha enviado correctamete para la incidencia #{@incidence.name}"
         when 2
          @email.send_pending @incidence
          @incidence.sended_pending=true
          @incidence.pending_date=Time.now
          @incidence.save
          success+="<br/>Correo de pendiente se ha enviado correctamete para la incidencia #{@incidence.name}"
         when 3
          @email.send_solution @incidence
          @incidence.sended_solution=true
          @incidence.solution_date=Time.now
          @incidence.save
          success+="<br/>Correo de solucionado se ha enviado correctamete para la incidencia #{@incidence.name}" 
         end
      
      end

      rescue => e
        Ramaze::Log.error e
        error+="La incidencia no se ha podido enviar por correo, vuelva a intentarlo o compruebe el archivo de configuracion"
        flash[:error] = "#{error}: #{e}"
        flash[:success] = success
        redirect_referrer
      end     

      flash[:success] = success
      redirect_referrer
  end

  def save
    redirect IncidencesController.r('login') unless session[:logged_in]
    model=request.params['model']
    send_email=request.params['send_email'].to_i
    name = request.params['name']
    task_created_from=request.params['task_created_from']
    branch_tiz=request.params['branch_tiz']
    phone_tiz=request.params['phone_tiz'] 
    branch=request.params['branch']
    location=request.params['location']
    address=request.params['address']
    name_of_claimant=request.params['name_of_claimant']
    phone_of_claimant=request.params['phone_of_claimant']
    problem=request.params['problem']
    problem_description=request.params['problem_description']
    
    error=""
    success="" 
    
    begin

      if name.nil? or name.empty?
        flash[:error] = 'Necesitamos el nombre de la tarea'
        raise "Necesitamos el nombre de la incidencia"
      end

      incidence=Incidence.new
      incidence.name = name
      incidence.task_create_from=task_created_from
      incidence.branch_tiz=branch_tiz
      incidence.phone_tiz=phone_tiz 
      incidence.branch=branch
      incidence.location=location
      incidence.address=address
      incidence.name_of_claimant=name_of_claimant
      incidence.phone_of_claimant=phone_of_claimant
      incidence.problem=problem
      incidence.problem_description=problem_description
      incidence.created_at = Time.now
      incidence.modified_at = Time.now
      incidence.motive_id=1
      incidence.sended_ack=false
      incidence.sended_pending=false
      incidence.sended_solution=false
      incidence.model=model

      
      incidence.save
      success="Incidencia creada correctamente"

      rescue => e
        Ramaze::Log.error e
        error+="Error al crear la inicidencia"
        flash[:error] = "#{error}: #{e}"
        redirect_referrer
      end
      
      begin

      if send_email ==1

        @email=MusicamEmail.new(EMAIL_CONFIG)
        @email.clean_smtp_cache

        case incidence.motive_id 
         when 1
        
            @email.send_ack incidence
            incidence.sended_ack=true
            incidence.acknowledgment_date=Time.now
            incidence.save
            success+="<br/>Acuse de recibo se ha enviado correctamete para la incidencia #{incidence.name}"
         end
      end
   
      flash[:success] = success
      redirect IncidencesController.r(nil)

      rescue => e
        Ramaze::Log.error e
        error+="La incidencia no se ha podido enviar por correo, vuelva a intentarlo o compruebe el archivo de configuracion"
        flash[:success] = success
        flash[:error] = "#{error}"
        redirect_referrer
      end
  end

  def sending_ack task_id 
    redirect IncidencesController.r('login') unless session[:logged_in]    
    @incidence=Incidence[task_id] 
    @email=MusicamEmail.new(EMAIL_CONFIG)
    @email.clean_smtp_cache
    
    error=""
    success=""

    begin

      if @incidence.nil?
        flash[:error] = 'No se ha podido enviar el correo cause de recibo'
        raise "No se ha podido enviar el correo cause de recibo"
      end

      @email.send_ack @incidence
      @incidence.sended_ack=true
      @incidence.acknowledgment_date=Time.now
      @incidence.save
      
      success="Acuse de recibo se ha enviado correctamete para la incidencia #{@incidence.name}"
      flash[:success] = success
      redirect IncidencesController.r(nil)

    rescue => e
      Ramaze::Log.error e
      error+="La incidencia no se ha podido enviar por correo, vuelva a intentarlo o compruebe el archivo de configuracion"
      flash[:error] = "#{error}: #{e}"
      redirect_referrer
    end
  end

  def sending_pending task_id 
    redirect IncidencesController.r('login') unless session[:logged_in]
    @incidence=Incidence[task_id] 
    @email=MusicamEmail.new(EMAIL_CONFIG)
    @email.clean_smtp_cache
    
    error=""
    success=""

    begin

      if @incidence.nil?
        flash[:error] = 'No se ha podido enviar por el correo de pendiente'
        raise "No se ha podido enviar por el correo de pendiente"
      end

      @email.send_pending @incidence
      @incidence.sended_pending=true
      @incidence.pending_date=Time.now
      @incidence.save
      
      success="Correo de pendiente se ha enviado correctamete para la incidencia #{@incidence.name}"
      flash[:success] = success
      redirect IncidencesController.r(nil)

    rescue => e
      Ramaze::Log.error e
      error+="La incidencia no se ha podido enviar por correo, vuelva a intentarlo o compruebe el archivo de configuracion"
      flash[:error] = "#{error}: #{e}"
      redirect_referrer
    end
  end

  def sending_solution task_id 
    
    redirect IncidencesController.r('login') unless session[:logged_in]
    @incidence=Incidence[task_id] 
    @email=MusicamEmail.new(EMAIL_CONFIG)
    @email.clean_smtp_cache
    
    error=""
    success=""

    begin

      if @incidence.nil?
        flash[:error] = 'No se ha podido enviar por el correo de pendiente'
        raise "No se ha podido enviar por el correo de pendiente"
      end

      @email.send_solution @incidence
      @incidence.sended_solution=true
      @incidence.solution_date=Time.now
      @incidence.save
      
      success="Correo de solucionado se ha enviado correctamete para la incidencia #{@incidence.name}"
      flash[:success] = success
      redirect IncidencesController.r(nil)

    rescue => e
      Ramaze::Log.error e
      error+="La incidencia no se ha podido enviar por correo, vuelva a intentarlo o compruebe el archivo de configuracion"
      flash[:error] = "#{error}: #{e}"
      redirect_referrer
    end
  end 

  def details id_task
    redirect IncidencesController.r('login') unless session[:logged_in]
    @incidence=Incidence[id_task]
  end
  
  def logout
    session.clear
    flash[:success] = 'You have been logged out'
    redirect IncidencesController.r(:login)
  end

end
