module SBConstants
  class StoreItem
    attr_accessor :name
  
    def initialize name
      @name = name
    end
  
    class << self
      attr_accessor :store
    
      def find_or_create_by_name name
        object = store.object_with_name(self, name)
        return object if object
        store.add_object(self, new_item = self.new(name))
        new_item
      end
      
      def all
        store.all_objects self
      end
    end
  end
end