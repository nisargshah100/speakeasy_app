USERS = [
  ["chris.anderson", "Chris Anderson"],
  ["jacqueline.chenault", "Jacqueline Chenault"],
  ["mike.chlipala", "Mike Chlipala"],
  ["mary.cutrali", "Mary Cutrali"],
  ["melanie.gilman", "Melanie Gilman"],
  ["andy.glass", "Andrew Glass"],
  ["austen.ito", "Austen Ito"],
  ["dan.kaufman", "Dan Kaufman"],
  ["tom.kiefhaber", "Tom Kiefhaber"],
  ["jan.koszewski", "Jan Koszewski"],
  ["chris.maddox", "Chris Maddox"],
  ["conan.rimmer", "Conan Rimmer"],
  ["darrell.rivera", "Darrell Rivera"],
  ["jonan.scheffler", "Jonan Scheffler"],
  ["nisarg.shah", "Nisarg Shah"],
  ["mike.silvis", "Mike Silvis"],
  ["charles.strahan", "Charles Strahan"],
  ["mark.tabler", "Mark Tabler"],
  ["andrew.thal", "Andrew Thal"],
  ["travis.valentine", "Travis Valentine"],
  ["michael.verdi", "Michael Verdi"],
  ["ed.weng", "Ed Weng"],
  ["horace.williams", "Horace Williams"],
  ["elise.worthy", "Elise Worthy"],
  ["jeff.casimir", "Jeff Casimir"],
  ["matt.yoho", "Matt Yoho"],
  ["josh.wehner", "Josh Wehner"],
  ["jessica.eldredge", "Jess Eldredge"]
]

USERS.each do |username, name|
  user = User.new
  user.email = "#{username}@livingsocial.com"
  user.name = name
  user.password = "hungry"
  user.is_admin = true
  user.save
end
