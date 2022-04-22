class SimpleWarehouse
  def initialize()
    ### initialize an empty warehouse instance var
    @wh_grid = Array.new(0) { Array.new(0) }
    ### initialize a list to keep track of crates
    @rect_list = []
    ### initialize a hash to associate crates with product codes
    @prod_hash = Hash.new
    @row_count = 0
  end

  def run
    @live = true
    puts 'Type `help` for instructions on usage'
    while @live
      print '> '
      command = gets.chomp.split
      # get base command
      command_base = command[0]
      ### switch statement to decide which method to call based on command entered
      case command_base
        when 'help'
          show_help_message
        when 'exit'
          exit
        when 'init'
          x = command[1].to_i
          y = command[2].to_i
          init_wh(x, y)
        when 'view'
          view
        when 'store'
          x = command[1].to_i
          y = command[2].to_i
          w = command[3].to_i
          h = command[4].to_i
          p_code = command[5]
          store(x, y, w, h, p_code)
        when 'locate'
          p_code = command[1]
          locate(p_code)
        when 'remove'
          x = command[1].to_i
          y = command[2].to_i
          remove(x, y)
        else
          show_unrecognized_message
      end
    end
  end

  def locate(p_code)
    ### check if product code is stored as key in product hash
    if @prod_hash.key?(p_code) && @prod_hash[p_code] != []
      p @prod_hash[p_code]
    else
      puts "Error: No such product in warehouse"
    end
  end

  def remove(x, y)
    ### in this function we loop through the list of stored crates 
    ### and if a match is found we store the index for later removal
    ### we also modify the visual representation of the warehouse grid accordingly
    idx = -1
    key = @wh_grid[x][y]
    @rect_list.each_with_index do |rect, index|
      valid = (rect[0] == x && rect[1] == y)
      if valid
        ### visual mmodification of wh_grid
        w = rect[2]
        h = rect[3]
        (x..(x+h)-1).each do |i|
          (y..(y+w)-1).each do |j|
            @wh_grid[i][j] = '*'
          end
        end
        idx = index
        break
      end
    end
    if(idx != -1)
      ### removal of crate from list
      @rect_list.delete_at(idx)
      inner_list = @prod_hash[key]
      inner_list.each_with_index do |rect, index|
        valid = (rect[0] == x && rect[1] == y)
        if valid
          idx = index
        end
      end
      ### removal of crate from prod hash
      ### note: if the idx of the crate was found in the crate list, it will also necessarily be found in the product hash
      inner_list.delete_at(idx)
      puts "Crate successfully removed"
    else
      puts "Error: no such crate at specified origin"
    end
  end

  def check_width_height?(w, h)
    return !(w == 0 || h == 0)
  end

  def store(x, y, w, h, p)
    ### parameter check
    if !check_width_height?(w, h)
      puts "Error: invalid width/height parameters"
    ### bounds check
    elsif x + h > @wh_grid.size || y + w > @wh_grid[0].size
      puts "Error: position outside of warehouse dimensions"
    ## check for overlap
    elsif overlap?(x, y, w, h)
      puts "Error: Crate does not fit (Overlap)"
    else
      (x..(x+h)-1).each do |i|
        (y..(y+w)-1).each do |j|
          ### this next line changes visual representation of wh_grid
          @wh_grid[i][j] = p
          ### logic to add crates to product hash and to list of all crates
          if i == x and y == j
            if @prod_hash.key?(p)
              @prod_hash[p].append([x, y, w, h])
            else
              @prod_hash[p] = []
              @prod_hash[p].append([x, y, w, h])
            end
           @rect_list.append([x, y, w, h])
          end
        end
      end
      puts "Crate stored successfully (type 'view' to see)"
    end
  end
  
  def rec_intersection?(rect1, rect2)
    ### utility function to determine if two rects overlap
    x_min = [rect1[0][0], rect2[0][0]].max
    x_max = [rect1[1][0], rect2[1][0]].min
    y_min = [rect1[0][1], rect2[0][1]].max
    y_max = [rect1[1][1], rect2[1][1]].min
    return false if ((x_max < x_min) || (y_max < y_min))
    return true
  end

  def overlap?(x, y, w, h)
    ### check if crates overlap (this method is called in store method above)
    store_rect = [[x, y], [x+h-1, y+w-1]] # x1, y1, x2, y2
    @rect_list.each do |rect|
      check_rect = [[rect[0], rect[1]], [rect[0] + rect[3]-1, rect[1] + rect[2]-1]] # x1, y1, x2, y2
      if rec_intersection?(store_rect, check_rect)
        return true
      end
    end
    return false
  end

  def init_wh(w, h)
    ### method to initialize wh_grid with proper values. Note: confusing and inconsistent use of w and h
    rows, cols = w, h
    @row_count = w
    @wh_grid = Array.new(rows) { Array.new(cols, '*') }
  end

  def view
    ### function to graphically display wh_grid from bottom up
    ### we just start from the bottom row up, logically the internal representation of wh_grid is the same
    row_c = @row_count - 1
    @wh_grid.each_with_index do |row, i|
      row.each_with_index do |column, j|
        elem = @wh_grid[row_c][j]
        print "#{elem} "
      end
      row_c -= 1
      puts
    end
  end

  def show_help_message
    puts <<~HELP
      help             Shows this help message
      init W H         (Re)Initialises the application as an empty W x H warehouse.
      store X Y W H P  Stores a crate of product code P and of size W x H at position (X,Y).
      locate P         Show a list of all locations occupied by product code P.
      remove X Y       Remove the entire crate occupying the location (X,Y).
      view             Output a visual representation of the current state of the grid.
      exit             Exits the application.
    HELP
  end

  def show_unrecognized_message
    puts 'Command not found. Type `help` for instructions on usage'
  end

  def exit
    puts 'Thank you for using simple_warehouse!'
    @live = false
  end

end