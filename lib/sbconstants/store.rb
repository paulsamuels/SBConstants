module SBConstants
  class Store
    def initialize
      @objects = Hash.new { |h,k| h[k] = Array.new }
    end
  
    def add_object klass, object
      @objects[klass] << object
    end
  
    def object_with_attrs klass, attrs
      @objects[klass].select { |o| 
        results = attrs.map { |k,v| o.send(k) == v }
        !results.include? false
      }.first
    end
    
    def all_objects klass
      @objects[klass]
    end
  end
end