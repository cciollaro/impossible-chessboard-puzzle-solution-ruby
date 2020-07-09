# just execute with
#     $ ruby main.rb
#
# there's a seed variable below that can be changed.
require 'json'

def print_board(board)
  puts board.map { |x| x.map {|bool| if bool then "h" else "t" end}.join(' ') }
end

def binary(number)
  number.to_s(2).rjust(6, "0")
end

def hash_board(board, debug=true)
  heads_in_vertical_1_wide_stripes = 0
  [1, 3, 5, 7].each do |x|
    (0...8).each do |y|
      heads_in_vertical_1_wide_stripes += 1 if board[y][x]
    end
  end
  puts "heads_in_vertical_1_wide_stripes: #{heads_in_vertical_1_wide_stripes}" if debug

  heads_in_vertical_2_wide_stripes = 0
  [2, 3, 6, 7].each do |x|
    (0...8).each do |y|
      heads_in_vertical_2_wide_stripes += 1 if board[y][x]
    end
  end
  puts "heads_in_vertical_2_wide_stripes: #{heads_in_vertical_2_wide_stripes}" if debug

  heads_in_vertical_4_wide_stripes = 0
  [4, 5, 6, 7].each do |x|
    (0...8).each do |y|
      heads_in_vertical_4_wide_stripes += 1 if board[y][x]
    end
  end
  puts "heads_in_vertical_4_wide_stripes: #{heads_in_vertical_4_wide_stripes}" if debug

  heads_in_horizontal_1_wide_stripes = 0
  (0...8).each do |x|
    [1, 3, 5, 7].each do |y|
      heads_in_horizontal_1_wide_stripes += 1 if board[y][x]
    end
  end
  puts "heads_in_horizontal_1_wide_stripes: #{heads_in_horizontal_1_wide_stripes}" if debug

  heads_in_horizontal_2_wide_stripes = 0
  (0...8).each do |x|
    [2, 3, 6, 7].each do |y|
      heads_in_horizontal_2_wide_stripes += 1 if board[y][x]
    end
  end
  puts "heads_in_horizontal_2_wide_stripes: #{heads_in_horizontal_2_wide_stripes}" if debug

  heads_in_horizontal_4_wide_stripes = 0
  (0...8).each do |x|
    [4, 5, 6, 7].each do |y|
      heads_in_horizontal_4_wide_stripes += 1 if board[y][x]
    end
  end
  puts "heads_in_horizontal_4_wide_stripes: #{heads_in_horizontal_4_wide_stripes}" if debug

  ((2**5) * (heads_in_horizontal_4_wide_stripes % 2) +
      (2**4) * (heads_in_horizontal_2_wide_stripes % 2) +
      (2**3) * (heads_in_horizontal_1_wide_stripes % 2) +
      (2**2) * (heads_in_vertical_4_wide_stripes % 2) +
      (2**1) * (heads_in_vertical_2_wide_stripes % 2) +
      (2**0) * (heads_in_vertical_1_wide_stripes % 2)) % 64
end

seed = 2
random = Random.new(seed)
board = (0...8).map { (0...8).map { [true, false].sample(random: random) }}
puts "Random board (seed=#{seed}):"
print_board(board)
puts
pre_flip_board_hash = hash_board(board, debug=false)
puts "pre_flip_board_hash: #{pre_flip_board_hash}"
puts
print "Warden puts key under coin (0-63): "
key_location = gets.to_i rescue nil
if key_location.nil? || !(0..63).include?(key_location)
  raise "Invalid key location #{key_location}. Must be between 0 and 63."
end
puts

# The commented section below is a neat little aside showing that each flip really does produce a unique board state
# positions_achievable_through_one_flip = []
# (0...8).each do |x|
#   (0...8).each do |y|
#     board_copy = JSON.parse(JSON.dump(board))
#     board_copy[y][x] = !board_copy[y][x]
#     positions_achievable_through_one_flip << hash_board(board_copy, debug=false)
#   end
# end
# puts "positions_achievable_through_one_flip: #{positions_achievable_through_one_flip.sort.inspect}"

puts "#{binary(pre_flip_board_hash)}: [#{pre_flip_board_hash}] pre_flip_board_hash"
puts "#{binary(key_location)}: [#{key_location}] key_location"
coin_to_flip = pre_flip_board_hash ^ key_location
puts "#{binary(coin_to_flip)}: [#{coin_to_flip}] pre_flip_board_hash XOR key_location"
puts

puts "Flipping coin #{coin_to_flip} (x=#{coin_to_flip % 8}, y=#{coin_to_flip / 8})"
puts
board_copy = JSON.parse(JSON.dump(board))
board_copy[coin_to_flip / 8][coin_to_flip % 8] = !board_copy[coin_to_flip / 8][coin_to_flip % 8]
post_flip_board_hash = hash_board(board_copy, debug=false)
puts "post_flip_board_hash: #{post_flip_board_hash}"
puts

if post_flip_board_hash == key_location
  puts "Success!!"
else
  puts "Uh oh..."
end
