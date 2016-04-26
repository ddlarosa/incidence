God.watch do |w|
  w.name = "rmxpanel"
  w.start = "rake ramaze:start -f /home/musicam/incidence/incidencepanel/Rakefile"
  w.keepalive
end
