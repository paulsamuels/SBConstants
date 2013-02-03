module SBConstants
  class Store
    def initialize
      @objects = Hash.new { |h,k| h[k] = Array.new }
    end
  
    def add_object klass, object
      @objects[klass] << object
    end
  
    def object_with_name klass, name
      @objects[klass].select { |o| o.name == name }.first
    end
    
    def all_objects klass
      @objects[klass]
    end
  end
end