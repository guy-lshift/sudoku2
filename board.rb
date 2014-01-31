require './cell.rb'

class Board

  attr_reader :number_solved

  def initialize
    @rows = Array.new(9) { |i| [] }
    @columns = Array.new(9) { |i| [] }
    @blocks = Array.new(9) { |i| [] }

    @cells = Array.new(81) { |i| Cell.new }
    arrange_cells_into_rows_and_columns
    arrange_cells_into_blocks

    @number_solved = 0
  end

  def set_cell_by_row_and_col(row, column, value)
    set_cell_by_cell(@rows[row][column], value)
  end

  def solve
    begin
      solved = @number_solved
      resolve_single_candidates
    end while solved < @number_solved
  end

  def print
    top_tail = '  +-------+-------+-------+'
    str = ""
    @rows.each_index do |i|      
      str += "\n#{top_tail}" if (i % 3 == 0)
      str += "  solved: #{@number_solved}" if i == 0
      str += "\n#{i+1} "
      @rows[i].each_index do |j|
      str += "| " if (j % 3 == 0)
        str += "#{@rows[i][j]} "
      end
      str += '|'
    end
    str + "\n#{top_tail}\n"
  end


  private

  def set_cell_by_cell(cell, value)
    if cell.set_value(value) then
      couples_for_cell(cell).each { |c| c.remove_candidate value }
      @number_solved += 1
    end
  end

  def couples_for_cell(cell)
    (@rows[cell.row] + @columns[cell.column] + @blocks[cell.block]).uniq.reject { |c| c === cell }
  end

  def resolve_single_candidates
    @cells.each do |c|
      set_cell_by_cell(c, c.candidates[0]) if c.candidates.length == 1
    end
  end

  def arrange_cells_into_rows_and_columns
    @cells.each_index do |i|
      row = i / 9
      @rows[row] << @cells[i]
      @cells[i].row = row

      column = i % 9
      @columns[column] << @cells[i]
      @cells[i].column = column
    end
  end

  def arrange_cells_into_blocks
    blocks = Array.new(3) { |i| Array.new(3) { |j| [] } }
    @blocks.each_index { |i| blocks[i / 3][i % 3] = @blocks[i]}
    @cells.each do |cell|
      block = blocks[cell.row / 3][cell.column / 3]
      block << cell
      cell.block = @blocks.find_index(block)
    end
  end

end
