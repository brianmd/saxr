require 'ox'
require "saxr/version"

module Saxr
  # remove_class :SuperSax

  # Extend Ox::Sax with #entity, which is called with tag name and attributes
  #    <tag a="3" b="test"> => will call: entity(:name, {a:"3", b:"test"})


  # Note: #parse converts special entities (e.g., &amp; => &)

  class SuperSax < ::Ox::Sax
    def self.default_path
      Pathname(default_directory) + default_filename
    end
    def self.default_directory
      '/Users/bmd/Documents/git/data/idw/xml/individual/'
    end
    def self.default_filename
      '0000000000011311320.csv'
    end
    def default_path
      self.class.default_path
    end
    def default_directory
      self.class.default_directory
    end
    def default_filename
      self.class.default_filename
    end

    def self.parse(filename: default_filename)
      self.new.parse(filename: filename)
    end
    def parse(filename: @filename)
      with_special_entities_converted do
        @filename = filename
        puts "\nparsing #{filename}"
        @result = nil
        path = default_directory + filename
        Pathname(path).open('r') do |input|
          handler = self  #.new
          Ox.sax_parse handler, input
        end
        @result
      end
    end

    def with_special_entities_converted
      orig = Ox::default_options[:convert_special]
      Ox::default_options = { :convert_special => true }

      yield
    ensure
      Ox::default_options = { :convert_special => orig }
    end

    def initialize(filename: default_filename)
      @filename = filename
      @line = nil
      @column = nil
      super()
      @entity_num = 0
      @entity_level = 0
      @entity_stack = []
      @attrs = Hash.new
    end

    def entity_creation_class
      @entity_creation_class ||= Hash
    end
    def entity_creation_class=(klass)
      @entity_creation_class = klass
    end

    def entity(name, attrs)
      puts "#{name.inspect} #{attrs.inspect}, level #{@entity_level}, line/column #{@line}/#{@column}"
    end

    def end_entity(name)
    end

    def start_element(name)
      @entity_num += 1
      @entity_level += 1
      @entity = name
      @attrs = Hash.new
    end

    def prev_element
      self[-2]
    end
    def prev_element_name
      prev_element.first
    end
    def parent
      self[-2]
    end
    def grandparent
      self[-3]
    end
    def [](index)
      @entity_stack[index]
    end
    
    def entity_stack
      @entity_stack
    end

    def attr(name, value)
      @attrs[name] = value
    end

    def attrs_done
      obj = entity_creation_class.new
      obj[:name] = @entity
      obj[:attrs] = @attrs
      @entity_stack << obj

      entity(@entity, @attrs)
    end
    
    def end_element(name)
      end_entity(name)
      @entity_level -= 1
      @entity_stack.pop
    end

    def error(message, line, column)
      puts "#{'!'*2000}\n\nERROR!!!!!\n\non line #{line}, column #{column}\n#{message}"
    end

    def cdata(value)
      raise 'unexpected cdata'
    end
  end
end

