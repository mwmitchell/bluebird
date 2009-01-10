proc {|base, files|
  $: << base unless $:.include?(base) || $:.include?(File.expand_path(base))
  files.each {|f| require f}
}.call(File.dirname(__FILE__), ['core_ext'])

require 'rubygems'
require 'hpricot'

module Bluebird
  
  def self.xml(xml)
    DSL.new(Hpricot::XML(xml))
  end
  
  class DSL
    
    attr_reader :doc, :templates
    
    def initialize(hpricot)
      @doc = hpricot
      @templates = []
    end
    
    def build(*a, &b)
      Hpricot.build(*a, &b)
    end
    
    def match(pattern, &block)
      @templates << {:pattern=>pattern, :block=>block}
    end
    
    def transform
      tpl = @templates.first
      new_doc=nil
      @doc.search(tpl[:pattern]).each do |n|
        result = instance_exec(n, &tpl[:block])
        if new_doc.nil?
          new_doc = Hpricot::XML(result.to_s)
        else
          new_doc << result
        end
      end
      new_doc
    end
    
    def call_template(pattern)
      matches = @doc.search(pattern)
      tpl_matches=[]
      tpl = @templates[1..-1].detect do |t|
        tpl_matches = @doc.search(t[:pattern])
        tpl_matches.any?{|n| matches.include?(n) }
      end
      @doc.search(tpl[:pattern]).collect do |n|
        instance_exec n, &tpl[:block]
      end
    end
    
  end
  
end