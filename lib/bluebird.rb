proc {|base, files|
  $: << base unless $:.include?(base) || $:.include?(File.expand_path(base))
  files.each {|f| require f}
}.call(File.dirname(__FILE__), ['core_ext'])
 
require 'rubygems'
require 'nokogiri'

module Bluebird
  
  def self.xml(f)
    DSL.new(Nokogiri::Slop(f))
  end
  
  Document = ::Nokogiri::XML::Document
  
  class InvalidTemplate < RuntimeError; end
  
  class DSL < Nokogiri::XML::Builder
    
    attr_reader :source, :templates, :root_template
    
    def initialize(source_doc)
      @source = source_doc
      @templates=[]
      super() do; end
    end
    
    def root_template?; ! @root_template.nil?; end
    
    # template '//PLANT'
    # template :plants=>'//PLANT'
    def template(pattern, opts={}, &blk)
      id, pattern = pattern.is_a?(Hash) ? [pattern.keys.first.to_sym, pattern.values.first] : [nil,pattern]
      @templates << {:id=>id, :pattern=>pattern, :opts=>opts, :block=>blk}
    end
    
    def root(opts={}, &blk)
      @templates << @root_template = {:id=>:root, :pattern=>@source.root.css_path, :opts=>opts, :block=>blk}
    end
    
    def transform
      if root_template?
        call_template :root
      else
        # execute all templates that don't have an id
        apply_templates
      end
      self
    end
    
    def call_template(id)
      tpl = @templates.detect{|t|t[:id]==id}
      raise InvalidTemplate.new("Template :#{id} not found") if tpl.nil?
      @source.search(tpl[:pattern]).each do |n|
        instance_exec n, &tpl[:block]
      end
    end
    
    def apply_templates(pattern=nil)
      if pattern
        node_set = @source.search(pattern)
        tpl_matches=[]
        tpl = @templates.detect do |t|
          tpl_matches = @source.search(t[:pattern])
          tpl_matches.any?{|n| node_set.include?(n) }
        end
        if tpl
          @source.search(tpl[:pattern]).each do |n|
            instance_exec n, &tpl[:block]
          end
        end
      else
        @templates.select{|t|t[:id]==nil}.each do |tpl|
          @source.search(tpl[:pattern]).each do |n|
            instance_exec n, &tpl[:block]
          end
        end
      end
    end
    
  end
   
end