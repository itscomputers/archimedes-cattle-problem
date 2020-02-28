class ContinuedFraction
	attr_reader :convergents

	def initialize(root)
		@root = root
		@approx = Math.sqrt(root).floor
		@alpha = [0, 1, 1]
		@convergents = [[0, 1], [1, 0]]
	end

	def quotient
		a, b, c = @alpha
		(a + b * @approx) / c
	end

	def next_alpha
		a, b, c = @alpha
		r = quotient * c - a
		alpha = [r * c, b * c, b**2 * @root - r**2]
		d = alpha.reduce(&:gcd)
		alpha.map { |x| x / d }
	end

	def next_convergent
		@convergents.reduce(&:zip).map { |(prev, curr)| prev + quotient * curr }
	end

	def advance
		@convergents = [*@convergents, next_convergent].drop(1)
		@alpha = next_alpha
	end

	def run
		advance until @alpha == [@approx, 1, 1]
		self
	end
end

class QuadraticInteger
	attr_reader :real, :imag, :root

	def initialize(real, imag, root)
		@real = real
		@imag = imag
		@root = root
	end

	def mult(other)
		real = @real * other.real + @imag * other.imag * @root
		imag = @real * other.imag + @imag * other.real
		QuadraticInteger.new(real, imag, @root)
	end
	
	def power(exponent)
		return QuadraticInteger.new(1, 0, @root) if exponent == 0
		return self if exponent == 1
		
		half_power = power(exponent / 2)
		return half_power.mult(half_power) if exponent % 2 == 0
		mult(half_power.mult(half_power))
	end
end

class CattleProblem
	def initialize
		@part_one = 50389082
		@root = 4729494
	end

	def first_solution
		ContinuedFraction.new(@root).run.convergents.last
	end

	def y_value
		QuadraticInteger.new(*first_solution, @root).power(2329).imag
	end

	def multiplier
		y_value**2 * 957 / 18628
	end

	def part_two
		(@part_one * multiplier).to_s
	end
end

SOLUTION = CattleProblem.new.part_two
NUMBER_OF_DIGITS = SOLUTION.length

puts <<~OUTPUT
#{SOLUTION}

solution: #{SOLUTION[0..24]}...#{SOLUTION[-25..-1]}

number of digits: #{NUMBER_OF_DIGITS}
OUTPUT
