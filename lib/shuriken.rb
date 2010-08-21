module Shuriken
  
  VERSION = "0.2.1".freeze
  
  def self.register_framework!
    Barista::Framework.register 'shuriken', File.expand_path('../coffeescripts', File.dirname(__FILE__))
  end
  
  register_framework! if defined? Barista::Framework
  
end
