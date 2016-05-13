class MusicamEmail 
 
  attr_reader :to, :from, :p, :content 
 
  def initialize(config)
    @from = config['from_address']
    @to = config['to_address']
    @p = config['p']

  end
 

  def clean_smtp_cache
    Net.instance_eval {remove_const :SMTPSession} if defined?(Net::SMTPSession)
    Net::POP.instance_eval {remove_const :Revision} if defined?(Net::POP::Revision)
    Net.instance_eval {remove_const :POP} if defined?(Net::POP)
    Net.instance_eval {remove_const :POPSession} if defined?(Net::POPSession)
    Net.instance_eval {remove_const :POP3Session} if defined?(Net::POP3Session)
    Net.instance_eval {remove_const :APOPSession} if defined?(Net::APOPSession)
  end

  def print_details
    puts "#{@from}" 
    puts "#{@to}"
    puts "#{@p}" 
  end 

  def send_ack incidence 

  task_name=incidence.name

@content = <<EOF
From: #{@from}
To: #{@to}
subject: CAU_TEMPLATE #{task_name}
Date: #{Time.now.rfc2822}
TEXT_ID=#{task_name}
TEXT_Averia=
F_LLegada_dia=
F_LLegada_mes=
F_LLegada_anyo=
F_LLegada_hora=
F_LLegada_min=
F_Salida_dia=
F_Salida_mes=
F_Salida_anyo=
F_Salida_hora=
F_Salida_min=
TEXT_Resumen=
     
SEL_MOTIVO=Acuse Recibo
BUTTON_Submit=Enviar
EOF

   Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)
   Net::SMTP.start('smtp.gmail.com', 587, 'gmail.com', from, p, :login) do |smtp|
   smtp.send_message(@content, @from, @to)
   end
   
  end 

  def send_pending incidence

  time=Time.now
  date_arr=time.to_s.split(' ')[0].to_s.split('-')
  time_arr=time.to_s.split(' ')[1].to_s.split(':')
  
  task_name=incidence.name
@content = <<EOF
From: #{@from}
To: #{@to}
subject: CAU_TEMPLATE #{task_name}
Date: #{Time.now.rfc2822}
TEXT_ID=#{task_name}
TEXT_Averia=
F_LLegada_dia=#{date_arr[2]}
F_LLegada_mes=#{date_arr[1]}
F_LLegada_anyo=#{date_arr[0]}
F_LLegada_hora=#{time_arr[0]}
F_LLegada_min=#{time_arr[1]}
F_Salida_dia=#{date_arr[2]}
F_Salida_mes=#{date_arr[1]}
F_Salida_anyo=#{date_arr[0]}
F_Salida_hora=#{time_arr[0]}
F_Salida_min=#{time_arr[01]}
TEXT_Resumen=#{incidence.pending}
     
SEL_MOTIVO=Pendiente
BUTTON_Submit=Enviar
EOF

   Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)
   Net::SMTP.start('smtp.gmail.com', 587, 'gmail.com', from, p, :login) do |smtp|
   smtp.send_message(@content, @from, @to)
   end
  end

  def send_solution incidence

  time=Time.now
  date_arr=time.to_s.split(' ')[0].to_s.split('-')
  time_arr=time.to_s.split(' ')[1].to_s.split(':')

  task_name=incidence.name
  
@content = <<EOF
From: #{@from}
To: #{@to}
subject: CAU_TEMPLATE #{task_name}
Date: #{Time.now.rfc2822}
TEXT_ID=#{task_name}
TEXT_Averia=
F_LLegada_dia=#{date_arr[2]}
F_LLegada_mes=#{date_arr[1]}
F_LLegada_anyo=#{date_arr[0]}
F_LLegada_hora=#{time_arr[0]}
F_LLegada_min=#{time_arr[1]}
F_Salida_dia=#{date_arr[2]}
F_Salida_mes=#{date_arr[1]}
F_Salida_anyo=#{date_arr[0]}
F_Salida_hora=#{time_arr[0]}
F_Salida_min=#{time_arr[1]}
TEXT_Resumen=#{incidence.solution}
     
SEL_MOTIVO=Solucion
BUTTON_Submit=Enviar
EOF

   Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)
   Net::SMTP.start('smtp.gmail.com', 587, 'gmail.com', from, p, :login) do |smtp|
   smtp.send_message(@content, @from, @to)
   end
  end

end