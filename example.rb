XML = %(<CATALOG>
	<PLANT>
		<COMMON>Bloodroot</COMMON>
		<BOTANICAL>Sanguinaria canadensis</BOTANICAL>
		<ZONE>4</ZONE>
		<LIGHT>Mostly Shady</LIGHT>
		<PRICE>$2.44</PRICE>
		<AVAILABILITY>031599</AVAILABILITY>
	</PLANT>
	<PLANT>
		<COMMON>Columbine</COMMON>
		<BOTANICAL>Aquilegia canadensis</BOTANICAL>
		<ZONE>3</ZONE>
		<LIGHT>Mostly Shady</LIGHT>
		<PRICE>$9.37</PRICE>
		<AVAILABILITY>030699</AVAILABILITY>
	</PLANT>
</CATALOG>)

EXPECTED = %(<?xml version="1.0"?>
<div zone="4"><dt>price</dt><dd>$2.44</dd><dt>name</dt><dd>Bloodroot</dd></div>
<div zone="3"><dt>price</dt><dd>$9.37</dd><dt>name</dt><dd>Columbine</dd></div>
<div/>
)

require './lib/bluebird'

bb = Bluebird.xml(XML)

bb.root do |n|
  div bb.call_template(:plant)
end

bb.template :plant=>'//PLANT' do |n|
  div({:zone=>n.at('ZONE').inner_text}) do
    dt 'price'
    dd n.at('PRICE').inner_text
    dt 'name'
    dd n.at('COMMON').inner_text
  end
end

result = bb.transform.to_xml
puts EXPECTED == result
puts result