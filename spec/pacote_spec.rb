$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../lib")

require 'pacote'

describe Pacote do
  
  before(:each) do
    
    @pacote1 = Pacote.new
    @pacote2 = Pacote.new

    @pacote1.preparar(:sedex, "58701050", "58701020").com(:peso, 20).com(:ar).com(:mao_propria).e_com(:valor_declarado, 100.0)
    @pacote2.preparar(:sedex, "58701050", "58701020").com(:peso, 30)
  end
  
  it "deveria armazenar a origem e destino do pacote" do
    @pacote1.origem.should eql("58701050")
    @pacote1.destino.should eql("58701020")
  end
  
  it "deveria armazenar o tipo do pacote" do
    @pacote1.should be_sedex
  end
  
  it "deveria armazenar o peso do pacote" do
    @pacote1.peso.should eql(20)
    @pacote2.peso.should eql(30)
  end
  
  it "deveria armazenar todos os opcionais do pacote" do
    @pacote1.should be_ar
    @pacote2.should_not be_ar
    
    @pacote1.should be_mao_propria
    @pacote2.should_not be_mao_propria
    
    @pacote1.should be_valor_declarado
    @pacote2.should_not be_valor_declarado
    
    @pacote1.valor_declarado.should eql(100.0)
  end
  
  
end