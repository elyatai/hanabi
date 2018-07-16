# hanabi language
# extension .hnb

require 'io/console'

$c = '.'

$commands = [
	# U D L R
	{code: [0, Integer, 0, 0], op: :push},
	{code: [0, Integer, 0, 1], op: :pushint},
	{code: [0, 0, 0, 2], op: :input},
	{code: [0, 0, 0, 3], op: :inputn},
	{code: [0, 0, 0, 4], op: :inputl},
	{code: [0, 1, 1, 0], op: :length},
	{code: [0, 0, 1, 0], op: :swap},
	{code: [0, 0, 1, 1], op: :reverse_a},
	{code: [0, 0, 1, Integer], op: :reverse},
	{code: [0, 0, 2, 0], op: :swap},
	{code: [0, 0, 2, 1], op: :rotateu_a},
	{code: [0, 0, 2, Integer], op: :rotateu},
	{code: [0, 1, 2, 0], op: :swap},
	{code: [0, 1, 2, 1], op: :rotated_a},
	{code: [0, 1, 2, Integer], op: :rotated},
	{code: [1, 0, 0, 0], op: :print},
	{code: [1, 1, 0, 0], op: :print_a},
	{code: [1, Integer, 0, 0], op: :print_m},
	{code: [1, 0, 0, 1], op: :printn},
	{code: [1, 1, 0, 1], op: :printn_a},
	{code: [1, Integer, 0, 1], op: :printn_m},
	{code: [1, 0, 0, 2], op: :newline},
	{code: [1, 0, 1, 0], op: :del},
	{code: [1, 0, 1, Integer], op: :del_m},
	{code: [1, 0, 2, 0], op: :del_a},
	{code: [2, 0, Integer, Integer], op: :duplicate},
	{code: [2, 1, 0, 0], op: :cond_eq},
	{code: [2, 1, 1, 1], op: :cond_neq},
	{code: [2, 1, 1, 0], op: :cond_lt},
	{code: [2, 1, 2, 0], op: :cond_lteq},
	{code: [2, 1, 0, 1], op: :cond_gt},
	{code: [2, 1, 0, 2], op: :cond_gteq},
	{code: [2, 2, Integer, 0], op: :math},
	{code: [2, 2, Integer, 1], op: :math},
	{code: [2, 2, 0, 2], op: :mod},
	{code: [2, 2, 1, 2], op: :div},
	{code: [2, 2, 2, 2], op: :divmod},
	{code: [2, 3, 0, 0], op: :not},
	{code: [3, Integer, 0, 0], op: :label},
	{code: [3, Integer, 0, 1], op: :goto_nz},
	{code: [3, Integer, 1, 0], op: :goto_z},
	{code: [3, Integer, 1, 1], op: :goto}
]

def parse code
	code = code.split "\n"
	length = code.map(&:length).max
	code.map! {|x| x.ljust(length).chars}

	dots = []
	code.each_with_index do |x, i|
		x.each_with_index do |y, j|
			dots.push [i, j] if y == $c
		end
	end

	commands = []
	dots.each do |d|
		cmd = []
		[[0, -1], [0, 1], [1, -1], [1, 1]].each do |x|
			c = d.dup
			n = -1
			begin
				n += 1
				c[x[0]] += x[1]
				raise "fell off edge of code at #{d}?" if c[0] < 0 || c[1] < 0 || c[0] >= code.length || c[1] >= code[0].length
			end while code[c[0]][c[1]] =~ /\s/
			cmd.push n
		end
		commands.push cmd
	end
#	puts commands.map{|x| x.inspect}
	return commands
end

def die cmd
	raise "command not found? #{cmd * ', '}"
end

def handle_math op, dir, r, l
	case op
	when 0
		return dir == 0 ? l+r : l-r
	when 1
		return dir == 0 ? l*r : l/r.to_f
	when 2
		return dir == 0 ? l**r : Math.log(r, l)
	else
		cur = 1
		r.times do
			cur = handle_math op-1, dir, cur, l
		end
		return cur
	end
end

def execute commands
	ops = []
	stack = []
	labels = []
	i = 0

	commands.each_with_index do |c, i|
		# p c
		ops[i] = ($commands.select{|x| x[:code].map.with_index { |e, j| e === c[j] } .all? } .first)[:op]
		# p ops[i]
		labels[c[1]] = i if ops[i] == :label
	end
	
	until i == commands.length
		c = commands[i]
		stack[-1] = stack[-1].to_i if stack[-1].ceil == stack[-1].floor if stack[-1]
		# p stack
		case ops[i]
		when :push
			stack.push c[1]
		when :pushint
			stack.concat c[1].to_s.bytes
		when :input
			stack.push STDIN.getch.ord
		when :inputn
			stack.push STDIN.gets.to_i
		when :inputl
			stack.concat STDIN.gets.chomp.bytes
		when :swap
			stack[-1], stack[-2] = stack[-2], stack[-1]
		when :reverse_a
			stack.reverse!
		when :reverse
			stack.concat stack.pop(c[3]).reverse
		when :rotateu_a
			stack.unshift stack.pop
		when :rotateu
			a = stack.pop(c[3])
			stack.push a[-1], *a[0...-1]
		when :rotated_a
			stack.push stack.shift
		when :rotated
			a = stack.pop(c[3])
			stack.push *a[1..-1], a[0]
		when :print
			print stack.pop.to_i.chr
		when :print_a
			print stack.reverse.map {|x| x.to_i.chr} * ''
			stack = []
		when :print_m
			print stack.pop(c[1]).reverse.map {|x| x.to_i.chr} * ''
		when :printn
			print stack.pop
		when :printn_a
			print stack.reverse * ''
			stack = []
		when :printn_m
			print stack.pop(c[1]).reverse * ''
		when :newline
			puts
		when :duplicate
			n = c[3] == 0 ? 1 : c[3]
			x = c[2] == 0 ? 1 : c[2]
			x.times do
				stack.concat stack[(-n)..-1]
			end
		when :math
			stack.push handle_math(c[2], c[3], stack.pop, stack.pop)
		when :div
			a = stack.pop
			stack.push stack.pop / a.to_i
		when :mod
			a = stack.pop
			stack.push stack.pop % a
		when :divmod
			a = stack.pop
			b = stack.pop
			stack.push (b / a.to_i), (b % a)
		when :not
			stack.push(stack.pop == 0 ? 1 : 0)
		when :label
			labels[c[1]] = i
		when :goto_nz
			raise "label #{c[1]} doesn't exist!" if !labels[c[1]]
			i = labels[c[1]] if stack.pop != 0
		when :goto_z
			raise "label #{c[1]} doesn't exist!" if !labels[c[1]]
			i = labels[c[1]] if stack.pop == 0
		when :goto
			raise "label #{c[1]} doesn't exist!" if !labels[c[1]]
			i = labels[c[1]]
		when :length
			stack.push stack.length
		when :cond_eq
			stack.push stack.pop == stack.pop ? 1 : 0
		when :cond_neq
			stack.push stack.pop != stack.pop ? 1 : 0
		# DO NOT CORRECT THIS SECTION, OPERATORS REVERSED ON PURPOSE
		when :cond_lt
			stack.push stack.pop > stack.pop ? 1 : 0
		when :cond_lteq
			stack.push stack.pop >= stack.pop ? 1 : 0
		when :cond_gt
			stack.push stack.pop < stack.pop ? 1 : 0
		when :cond_gteq
			stack.push stack.pop <= stack.pop ? 1 : 0
		# DO NOT CORRECT THIS SECTION, OPERATORS REVERSED ON PURPOSE
		when :del
			stack.pop
		when :del_m
			stack.pop c[3]
		when :del_a
			stack = []
		end
		i += 1
	end
	# p stack
end

raise "no file given?" if !ARGV[0]

code = File.read(ARGV[0])
execute(parse code)