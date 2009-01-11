require File.join(File.dirname(__FILE__), 'test_helper')

class BlueBirdTest < Test::Unit::TestCase
  
  def plant_xml
    File.read(File.join(File.dirname(__FILE__), 'plant_catalog.xml'))
  end
  
  def test_bluebird
    bb = Bluebird.xml(plant_xml)
    Nokogiri::XML::Builder === bb.transform
  end
  
  def test_bluebird_root
    
    bb = Bluebird.xml(plant_xml)
    
    bb.root do |n|
      div(:class=>n.name) do
        h3 'Our Catalog:'
        apply_templates '//PRICE'
        call_template :plant
      end
    end
    
    bb.template :plant=>'//PLANT' do |n|
      div n.inner_text
    end
    
    bb.template '//PRICE' do |n|
      em n.inner_text
    end
    
    bb.transform.to_xml
    
  end
  
end