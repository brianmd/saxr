require 'spec_helper'

class Example < Saxr::SuperSax
  def self.default_directory
    Pathname(__FILE__).expand_path.dirname
  end

  def self.default_filename
    'example.xml'
  end
end

describe 'Saxr::SuperSax' do
  let(:filename) { 'example.xml' }


  context 'parses' do
    it 'real good' do
      sax = Example.parse
    end
  end
end
