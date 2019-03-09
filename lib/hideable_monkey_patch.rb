module Hideable
  module ActiveRecord
    module InstanceMethods
      def hidden?
        self.hidden_at.present?
      end
    end
  end
end
