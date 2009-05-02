class Pacote
  attr_reader :origem, :destino, :tipo, :peso, :ar, :mao_propria, :valor_declarado, :valor_declarado_valor
  
  def preparar(tipo, origem, destino)
    @tipo = tipo
    @origem = origem
    @destino = destino
    
    self
  end
  
  def com(servico, valor=nil)
    case servico
      when :peso then @peso = valor 
      when :ar then @ar = true
      when :mao_propria then @mao_propria = true
      when :valor_declarado then @valor_declarado_valor = valor; @valor_declarado = true
    end
    self
  end
  alias_method :e_com, :com
  
  def sedex?
    @tipo == :sedex
  end
  
  def ar?
    @ar
  end
  
  def mao_propria?
    @mao_propria
  end
  
  def valor_declarado?
    @valor_declarado
  end
  
  def valor_declarado
    @valor_declarado_valor
  end
  
end