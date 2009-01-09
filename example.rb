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

EXPECTED = %(
<div>
  <div>
    <dt>price</dt>
    <dd>$2.44</dd>
    <dt>name</dt>
    <dd>Bloodroot</dd>
  </div>
  <div>
    <dt>price</dt>
    <dd>$9.37</dd>
    <dt>name</dt>
    <dd>Columbine</dd>
  </div>
</div>
).gsub(/\n|\t/, '').gsub(/ +/, '').to_s # remove the spaces, tabs and line breaks

bb = Bluebird.xml(XML)

bb.match '/' do |n|
  build do
    div bb.call_template('//PLANT')
  end
end

bb.match '//PLANT' do |n|
  build do
    div do
      dt 'price'
      dd n.at('PRICE').inner_text
      dt 'name'
      dd n.at('COMMON').inner_text
    end
  end
end

EXPECTED == bb.transform.to_s == true