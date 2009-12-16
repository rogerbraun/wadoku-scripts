# coding: utf-8
require "romkan-utf.rb"

input = File.open("entries.csv")

entries = Array.new

input.each do |line|

  line.gsub!("^","\^")
  line.gsub!(" "," ") 
  line.gsub!(" "," ");
  line.gsub!("　"," ");
  schreibung, lesung, bedeutung, pos = line.split("!!BREAK!!")

### BEDEUTUNG
  bedeutung.gsub!(/<span class="Gen">(.)<\/span>/) do " (#{$~[1]})" end
  bedeutung.gsub!(/<span class="dom">(.*?)<\/span>/) do " \\textit{#{$~[1]}}" end


  bedeutung.gsub!(/<\/?span.*?>/,"")
  bedeutung.gsub!(/<span.*/,"")
  bedeutung.gsub!(/<.*>/,"")
  
  lesung.gsub!(/\[.*\]/,"")
  schreibung.gsub!(";","・")
  bedeutung.gsub!("&","\\&")
  lesung.gsub!("&","\\&")
  bedeutung.gsub!("_","")
  bedeutung.strip!
  lesung.strip!
  schreibung.strip!
  
  schreibung.gsub!(/ \[.\]/,"")

  arr = {:bedeutung => bedeutung, :schreibung => schreibung, :lesung => lesung, :pos => pos }
  entries.push(arr) 
end

entries.sort{|x,y| x[:lesung].to_roma <=> y[:lesung].to_roma}.each do |entry|
  
  puts "\\begin{entry}\n\\mainentry{#{entry[:lesung].to_roma}}\n{#{entry[:schreibung]}}{ \\textbf{#{entry[:pos]}}}\n{#{entry[:bedeutung]}}\\end{entry}"
end
