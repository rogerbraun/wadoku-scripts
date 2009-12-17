# coding: utf-8
require "romkan-utf.rb"

input = File.open("WaDoku.tab")

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

id, schreibung, lesung, deutsch, eintragart, tonakzent, sechs, sieben, acht, neun, zehn, elf, zwoelf, dreizehn = line.split("\t")

puts "ID:#{id}, Schreibung:#{schreibung}, Lesung:#{lesung}, Übersetzung:#{deutsch}, Eintragart:#{eintragart}"

pos = deutsch[/<POS: (.).*?>/,1] 
dom = deutsch[/<Dom\.: (.*?)>/,1] 

tex = "\\begin{entry}
\\lemma{#{lesung.to_roma}}
\\schreibung{#{schreibung}}  
\\pos{#{pos}}
\\domaene{#{dom}}
\\uebersetzung{#{deutsch}}
\\end{entry}"


if eintragart.strip == "HE" then
  entries[schreibung] = Hash.new unless entries[schreibung]
  entries[schreibung][:haupteintrag] = tex
  entries[schreibung][:nebeneintraege] = Array.new unless entries[schreibung][:nebeneintraege]
else

  entries[eintragart] = Hash.new unless entries[eintragart]
  entries[eintragart][:nebeneintraege] = Array.new unless entries[eintragart][:nebeneintraege]
  entries[eintragart][:nebeneintraege].push(tex)
end

end

puts entries.count

entries.each do |x, y|
  
  puts "\\begin{haupteintrag}"
  puts y[:haupteintrag]
  puts "\\end{haupteintrag}"
  puts "\\begin{untereintraege}"

  y[:nebeneintraege].each do |eintrag|
    puts eintrag
  end  
  
  puts "\\end{untereintrage}"

end
