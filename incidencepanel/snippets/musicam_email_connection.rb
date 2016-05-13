class MusicamEmailConnection 
 
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

  def send_ack connection,musicam_worker 

  manager=connection.manager
  branch=connection.group.name
  musicam_worker=musicam_worker

@content = <<EOF
From: #{@from}
To: #{@to}
subject: AVERIA INABENSA #{branch}

Soy #{musicam_worker} de departamento técnico  de Musicam, no hemos podido realizar una de nuestras descargas periódicas en el centro #{branch}.

Intentamos repararla telefónicamente, con ayuda de #{manager}, pero ha sido imposible, se detecta avería de cableado.

Por favor, remitir una incidencia a INABENSA para que asistan a solucionarlo.

Si necesitáis alguna información adicional no dudéis en contactar con nosotros (tlf 607516105).

Saludos
EOF

   Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)
   Net::SMTP.start('smtp.gmail.com', 587, 'gmail.com', from, p, :login) do |smtp|
   smtp.send_message(@content, @from, @to)
   end
   
  end 
  
end