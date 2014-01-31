require 'test/unit'
require './board.rb'
require './cell.rb'


class BoardTest < Test::Unit::TestCase

  def setup
    @board = Board.new
  end

  def test_board_has_9_rows_with_9_cells_each
    expected = [Cell, Cell, Cell, Cell, Cell, Cell, Cell, Cell, Cell]
    for i in 0..8
      assert_equal expected, @board.instance_variable_get(:@rows)[i].map { |c| c.class }
    end
  end

  def test_board_has_9_columns_with_9_cells_each
    expected = [Cell, Cell, Cell, Cell, Cell, Cell, Cell, Cell, Cell]
    for i in 0..8
      assert_equal expected, @board.instance_variable_get(:@columns)[i].map { |c| c.class }
    end
  end

  def test_board_has_81_cells_total
    rows = @board.instance_variable_get(:@rows)
    columns = @board.instance_variable_get(:@columns)
    assert_equal 81, (rows + columns).flatten.uniq.length
  end

  def test_a_cell_knows_its_row
    row_4 = @board.instance_variable_get(:@rows)[4]
    assert_equal 4, row_4[7].row
  end

  def test_a_cell_knows_its_column
    col_2 = @board.instance_variable_get(:@columns)[2]
    assert_equal 2, col_2[7].column
  end

  def test_board_has_9_blocks_with_9_cells_each
    expected = [Cell, Cell, Cell, Cell, Cell, Cell, Cell, Cell, Cell]
    for i in 0..8
      assert_equal expected, @board.instance_variable_get(:@blocks)[i].map { |c| c.class }
    end
  end

  def test_a_cell_knows_its_block
    block_6 = @board.instance_variable_get(:@blocks)[6]
    assert_equal 6, block_6[2].block
  end

  def test_board_can_see_couples_for_a_cell
    cells = board_cells

    # cell 4 is row 0, column 4
    cell = cells[4]

    expected = [
      cells[0], cells[1], cells[2],
      cells[3], cells[5],
      cells[6], cells[7], cells[8],
      cells[12], cells[13], cells[14],
      cells[21], cells[22], cells[23],
      cells[31], cells[40], cells[49], cells[58], cells[67], cells[76], 
    ].sort

    actual = @board.send(:couples_for_cell, cell).sort

    assert_equal expected, actual
  end

  def test_board_can_set_value_of_cell_by_row_and_col
    @board.set_cell_by_row_and_col(3, 5, 7)
    assert_equal 7, board_cells[32].value
  end

  def test_board_can_set_value_of_cell_by_cell
    cell = board_cells[32]
    @board.send(:set_cell_by_cell, cell, 7)

    assert_equal 7, board_cells[32].value
  end

  def test_setting_value_of_cell_removes_candidates_from_couples
    @board.set_cell_by_row_and_col(3, 5, 7)
    cell = board_cells[32]
    couples = @board.send(:couples_for_cell, cell)

    expected = [1, 2, 3, 4, 5, 6, 8, 9]

    couples.each { |c| assert_equal expected, c.candidates }
  end

  def test_board_can_resolve_single_candidates
    cell = board_cells[0]
    cell.instance_variable_set :@candidates, [7]

    @board.send :resolve_single_candidates

    assert_equal 7, cell.value
    assert_equal [], cell.instance_variable_get(:@candidates)
  end

  def test_board_knows_how_many_cells_are_solved
    assert_equal 0, @board.number_solved
    @board.set_cell_by_row_and_col 1, 2, 3
    assert_equal 1, @board.number_solved
  end

  def test_solve_resolves_one_candidate
    cell_0 = board_cells[0]
    cell_0.instance_variable_set :@candidates, [7]

    @board.solve

    assert_equal 7, cell_0.value, 'cell 0 not solved'
  end

  def test_solve_incrementally_resolves_two_candidates
    cell_0 = board_rows[0][0]
    cell_0.instance_variable_set :@candidates, [7]

    cell_1 = board_rows[1][2]
    cell_1.instance_variable_set :@candidates, [3, 7]

    @board.solve

    assert_equal 7, cell_0.value, 'cell 0 not solved'
    assert_equal 3, cell_1.value, 'cell 1 not solved'
  end

  def test_solve_incrementally_resolves_multiple_candidates
    cell_0 = board_rows[0][0]
    cell_0.instance_variable_set :@candidates, [7]

    cell_1 = board_rows[1][2]
    cell_1.instance_variable_set :@candidates, [3, 7]

    cell_2 = board_rows[5][2]
    cell_2.instance_variable_set :@candidates, [3, 4]

    cell_3 = board_rows[0][2]
    cell_3.instance_variable_set :@candidates, [1, 3, 4, 7]

    @board.solve

    assert_equal 7, cell_0.value, 'cell 0 not solved'
    assert_equal 3, cell_1.value, 'cell 1 not solved'
    assert_equal 4, cell_2.value, 'cell 2 not solved'
    assert_equal 1, cell_3.value, 'cell 3 not solved'
  end

  def test_setting_cell_with_existing_value_doesnt_increment_solved_count
    @board.set_cell_by_row_and_col(1, 2, 3)
    @board.set_cell_by_row_and_col(1, 2, 4)

    assert_equal 1, @board.number_solved
  end


  private

  def board_cells
    @board.instance_variable_get :@cells
  end

  def board_rows
    @board.instance_variable_get :@rows
  end

end
