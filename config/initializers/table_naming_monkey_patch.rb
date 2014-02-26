module ActiveRecord
  module Reflection
    class AssociationReflection < MacroReflection
      def derive_join_table
        [active_record.table_name, klass.table_name].sort.join("_")
      end
    end
  end
end