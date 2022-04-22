require_relative "./simple_warehouse"
require 'minitest/autorun'

class WarehouseTest < Minitest::Test

    def setup()
        @warehouse = SimpleWarehouse.new
        @warehouse.init_wh(8, 10)
        @wh_grid = @warehouse.instance_variable_get(:@wh_grid)
    end

    def test_init
        puts "Testing warehouse initialization..."
        assert @wh_grid.length() == 8
        @wh_grid.each do |row|
            assert row.length == 10
        end
    end

    def test_store
        puts "Testing store..."
        assert_output("Crate stored successfully (type 'view' to see)\n") { @warehouse.store(3, 4, 2, 3, 'q') }
        assert @wh_grid[4][5] == 'q'
        assert_output("Error: position outside of warehouse dimensions\n") { @warehouse.store(19, 19, 2, 3, 'r')}
        assert_output("Error: position outside of warehouse dimensions\n") { @warehouse.store(4, 5, 7, 2, 'a')}
        assert_output("Error: Crate does not fit (Overlap)\n") { @warehouse.store(4, 5, 2, 2, 'a')}
    end

    def test_locate_and_remove
        puts "Testing locate and remove..."
        assert_output("Crate stored successfully (type 'view' to see)\n") {@warehouse.store(1, 1, 2, 2, "p")}
        assert_output("Crate stored successfully (type 'view' to see)\n") {@warehouse.store(4, 5, 2, 1, "p")}
        assert_output("[[1, 1, 2, 2], [4, 5, 2, 1]]\n") {@warehouse.locate("p")}
        assert_output("Crate successfully removed\n") {@warehouse.remove(4, 5)}
        assert_output("[[1, 1, 2, 2]]\n") {@warehouse.locate("p")}
        assert_output("Crate successfully removed\n") {@warehouse.remove(1, 1)}
        assert_output("Error: No such product in warehouse\n") {@warehouse.locate("p")}
        assert_output("Error: no such crate at specified origin\n") {@warehouse.remove(2, 3)}
    end
end

