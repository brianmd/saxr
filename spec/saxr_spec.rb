require 'spec_helper'

class Example < Saxr::SuperSax
  def self.default_directory
    Pathname(__FILE__).expand_path.dirname
  end

  def self.default_filename
    'example.xml'
  end

  def entity(name, attrs)
    entities << [name, attrs]
  end

  def text(value)
    texts << [parent[:name], value.strip]
  end

  def entities
    @entities ||= []
  end

  def texts
    @texts ||= []
  end
end

describe 'Saxr::SuperSax' do
  before(:all) {
    @sax = Example.new
    @sax.parse
  }
  let(:filename) { 'example.xml' }

  context 'parses' do
    it 'captures complete entities' do
      expect(@sax.entities).to eq([[:a, {:attr1=>"3"}], [:b, {}], [:cs, {}], [:c1, {}], [:c2, {:c2=>"abc", :y=>"4"}]])
    end

    it 'captures the text portions' do
      expect(@sax.texts).to eq([[:a, "hello world"], [:cs, "i r c2"]])
    end
  end
end
