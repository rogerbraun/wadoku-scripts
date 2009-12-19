# coding: utf-8
require "romkan-utf.rb"

input = File.open("WaDokusmall.tab")

entries = Hash.new

#input.each do |line|
#  id, japanisch, lesung, deutsch, = line.split("\t")
#end
#
#entries.sort{|x,y| x[:lesung].to_roma <=> y[:lesung].to_roma}.each do |entry|
#  
#  puts "\\begin{entry}\n\\mainentry{#{entry[:lesung].to_roma}}\n{#{entry[:schreibung]}}{ \\textbf{#{entry[:pos]}}}\n{#{entry[:bedeutung]}}\\end{entry}"
#end
input.each do |line| 
  c = 0

  #CLEANUP
  line.gsub!("§","\\S")
  line.gsub!("$","\\$")
  line.gsub!("&","\\\\&")
  line.gsub!("＆","\\&")
  line.gsub!("_","\\_")
  line.gsub!("^","\\^{}")
  line.gsub!("%","\\%")
  line.gsub!("#","\\#")
  line.gsub!("~","\\textasciitilde")
  line.gsub!("","")
  #Auftrennen
  id, schreibung, lesung, deutsch, eintragart, tonakzent, sechs, sieben, acht, neun, zehn, elf, zwoelf, dreizehn = line.split("\t")


  #Felder generieren
  pos = deutsch[/<POS: (.*?)>/,1] 
  dom = deutsch[/<Dom\.: (.*?)>/,1] 

  #Felder modifizieren

  schreibung.gsub!(/\[.\]/,"")
  schreibung.gsub!("　","")
  schreibung.gsub!(" ","")

  lesung.gsub!(/\[.\]/,"")
  deutsch.gsub!(/<Gen\.: (.*?)>/) {" (\\textit{#{$~[1]}})"}
  deutsch.gsub!(/<FamN\.: (.*?)>/) {"\\textsc{#{$~[1]}}"}
  deutsch.gsub!(/\(<.*?>\)/,"") 
  deutsch.gsub!(/<.*?>/,"") 
  #Texrepräsentation erstellen

  tex = "\\lemma{#{lesung.to_roma.strip}}\n\\schreibung{#{schreibung.strip}}"  
  tex += "\\pos{#{pos}}" if pos
  tex += "\\domaene{#{dom}}" if dom
  tex += "\\uebersetzung{#{deutsch.strip}}"


  #Einträge in den Hash schreiben
  if eintragart.strip == "HE" then
    entries[schreibung] = Hash.new unless entries[schreibung]
    entries[schreibung][:haupteintrag] = tex
    entries[schreibung][:lesung] = lesung.to_roma
    entries[schreibung][:nebeneintraege] = Array.new unless entries[schreibung][:nebeneintraege]
  else
    entries[eintragart] = Hash.new unless entries[eintragart]
    entries[eintragart][:nebeneintraege] = Array.new unless entries[eintragart][:nebeneintraege]
    entries[eintragart][:nebeneintraege].push(tex)
    entries[eintragart][:lesung] = lesung.to_roma unless entries[eintragart][:lesung]
  end

end

#Einträge ausgeben

entries.sort{|x, y| x[1][:lesung]<=>y[1][:lesung]}.each do |x, y|
  puts "\\begin{entry}"
  puts "\\begin{haupteintrag}"
  puts y[:haupteintrag] if y[:haupteintrag]
  puts "\\end{haupteintrag}"
  puts "\\begin{untereintraege}"

  y[:nebeneintraege].each do |eintrag|
    puts eintrag.gsub("\\lemma","\\sublemma")
  end  
  
  puts "\\end{untereintraege}"
  puts "\\end{entry}"
end
