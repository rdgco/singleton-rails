module ActiveRecord
  module Singleton
    extend ActiveSupport::Concern

    module ClassMethods

      def instance
        first || new
      end

    end

    private

    def create_or_update(*args, &block)
      run_callbacks(:save) do
        raise ReadOnlyRecord if readonly?

        # Singleton record
        singleton = self.class.first

        # Force overriding the one-and-only singleton record (if any)
        self.id = singleton.id if singleton

        # Update if a singleton record is found, otherwise insert one
        result = singleton ? _update_record(*args, &block) : _create_record(&block)
        result != false
      end
    end

  end
end
