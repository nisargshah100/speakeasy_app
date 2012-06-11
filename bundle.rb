puts `cd speakeasy_bouncer; rake db:migrate; bundle; cd ..`
puts `cd speakeasy_core; rake db:migrate; bundle; cd ..`
puts `cd speakeasy_dumbwaiter; bundle; cd ..`
puts `cd speakeasy_github; rake db:migrate; bundle; cd ..`
puts `cd speakeasy_gumshoe; rake db:migrate; bundle; cd ..`
puts `cd speakeasy_vaudeville; rake db:migrate; bundle; cd ..`