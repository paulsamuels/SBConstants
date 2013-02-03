module SBConstants
  class StoreItem    
    class << self
      attr_accessor :store
    
      def find_or_create attrs
        object = store.object_with_attrs(self, attrs)
        return object if object
        store.add_object(self, new_item = self.create(attrs))
        new_item
      end
            
      def all
        store.all_objects self
      end
      
      def create attrs={}
        instance = self.new
        attrs.each do |key, value|
          instance.send("#{key}=", value)
        end
        instance
      end
    end
  end
end