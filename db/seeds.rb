open("db/seeds/seed_email_list.csv") do |f|
  f.read.each_line do |recipient|
    puts recipient.inspect
    name, email = recipient.downcase.chomp.split(",")
    unless User.where(email: email).first
      first_name, last_name = User.chomp_user_name(name)
      User.create!(
                   first_name: first_name.capitalize,
                   last_name: last_name.capitalize,
                   email: email,
                   password: Devise.friendly_token[0, 20])
    end
  end
end
