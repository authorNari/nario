Dir['*.PNG'].each { |f|   File.rename(f,f.downcase)}
