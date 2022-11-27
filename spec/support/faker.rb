module Faker
  class LegacyUnit
    class << self
      def unit
        ['kg', '1L', '100ml', 'piece', 'bunch', '500g'].sample
      end
    end
  end

  class Unit
    class << self
      def units
        ['KGM', 'GRM', 'LTR']
      end

      def unit
        units.sample
      end
    end
  end
end
