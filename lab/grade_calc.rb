scores = []
puts "How many scores? "
n = gets.chomp.to_i

while n < 1 do 
  puts "Invalid number of scores";
  puts "How many scores? "
  n = gets.chomp.to_i
end

n.times do |i|
  puts "Enter score #{i + 1}: "
  sco = gets.chomp
  while sco.to_i < 0 || sco.to_i > 100 do
    puts "Invalid score"
    puts "Enter score #{i + 1}: "
    sco = gets.chomp
  end
  scores << sco.to_i
end



avg = scores.sum / n

puts "Average: #{avg}"

grade = if avg >= 90 then "A"
  elsif avg >= 80 then "B"
  elsif avg >= 70 then "C"
  elsif avg >= 60 then "D"
  else "F"
  end

puts "Letter Grade: #{grade}"
puts "Highest: #{scores.max}"
puts "Lowest: #{scores.min}"