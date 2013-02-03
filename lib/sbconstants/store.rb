module SBConstants
  class Store
    def initialize
      @objects = Hash.new { |h,k| h[k] = Array.new }
    end
    
    def find_or_create klass, attrs
      object = object_with_attrs(klass, attrs)
      return object if object
      add_object(klass, new_item = klass.create(attrs))
      new_item
    end
    
    def all klass
      @objects[klass]
    end
    
    private
  
    def add_object klass, object
      @objects[klass] << object
    end
  
    def object_with_attrs klass, attrs
      @objects[klass].select { |o| 
        results = attrs.map { |k,v| o.send(k) == v }
        !results.include? false
      }.first
    end
  end
end