require "rubygems"
require "lib/correios"

# obtendo as informacoes de uma encomenda
=begin
encomenda = Correios.encomenda("ES446391025BR")

puts "Encomenda: #{encomenda.numero}"
puts
encomenda.status.each do |status|
  puts "  data: #{status.data}"
  puts "  local: #{status.local}"
  puts "  situacao: #{status.situacao}"
  puts "  detalhes: #{status.detalhes}"
  puts
end
=end

Correios.sedex()