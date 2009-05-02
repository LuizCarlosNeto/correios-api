require "rubygems"
require "net/http"
require "hpricot"
require "open-uri"
require "lib/encomenda"
require "lib/encomenda_status"

class Correios
  @url = "http://websro.correios.com.br"
  @url_rastreamento = "#{@url}/sro_bin/txect01$.QueryList?P_ITEMCODE=&P_LINGUA=001&P_TESTE=&P_TIPO=001&P_COD_UNI="
  @url_calculo = "http://www.correios.com.br/encomendas/precos/calculo.cfm"
  
  def self.encomenda(numero, url=@url_rastreamento)
    html = Hpricot(open("#{url}#{numero}"))
    encomenda = Encomenda.new(numero)
    
    pula_tr = true
    (html/"tr").each do |tr|
       status = nil
       status = self.parse_tr(encomenda, tr) if not pula_tr
       encomenda << status if not status.nil?
       pula_tr = false
    end
    return encomenda
  end
  
  def self.sedex(caracts={}, url=@url_calculo)
    url += "?resposta=&servico=41106"
    url += "&cepOrigem=#{caracts[:origem]}"
    url += "&cepDestino=#{caracts[:destino]}"
    url += "&peso=#{caracts[:peso]}"
    url += "&avisoRecebimento=S" if caracts[:opcionais].include? :ar 
    url += "&MaoPropria=S" if caracts[:opcionais].include? :mao_propria
    #url += "&valorDeclarado=S" if caracts[:opcionais].include

    html = Hpricot(open(url))
    script_javascript = html.at("script").inner_html
  
    tarifa = script_javascript.scan(/Tarifa=[0-9|.]+/).first.split("=")[1]
    #TODO erro =
    
     
  end
  
=begin
  def self.pac(origem, destino, peso,)
    servico = 41106 #PAC
    cepOrigem = ''
    cepDestino = ''
    peso = 0.3
    formato = 1 #caixapacote
    comprimento =
    largura
    altura 
  end
=end
  
  private
  def self.parse_tr(encomenda, tr)
    status = nil
    td_count = 0
    (tr/"td").each do |td|
      if td_count == 0
        if td.inner_html =~ /\d{2}\/\d{2}\/\d{4} \d{2}:\d{2}/
          status = EncomendaStatus.new
          parsed_data = td.inner_html.scan(/(\d{2})\/(\d{2})\/(\d{4}) (\d{2}):(\d{2})/)
          timestamp = parsed_data[0][2] + parsed_data[0][1] + parsed_data[0][0] + parsed_data[0][3] + parsed_data[0][4] + "00"
          status.data = DateTime.parse(timestamp)
        else
          encomenda.primeiro_status_disponivel.detalhes = td.inner_html
        end
      end

      status.local = td.inner_html if td_count == 1
      if td_count == 2
        parsed_situacao = td.inner_html.scan(/.*>(.*)<.*/)
        status.situacao = parsed_situacao[0][0]
      end

      td_count += 1
    end
    
    return status
  end
  
end