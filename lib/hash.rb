# TODO Put these and other little helpers into gem(s)

class Hash

  # >> { :a => 1, :b => 2 }.pass(:a)
  # => { :a => 1 }
  #
  # >> { :abc => 1, :bbc => 2 }.pass(/^ab/)
  # => { :abc => 1 }
  #
  def pass(*keys)
    if keys.first.is_a?(Regexp)
      reject { |k,v| k !~ keys.first }
    else
      reject { |k,v| !keys.include?(k) }
    end
  end

  # >> { :a => 1, :b => 2 }.block(:a)
  # => { :b => 2 }
  #
  # >> { :abc => 1, :bbc => 2 }.block(/^ab/)
  # => { :bbc => 2 }
  #
  def block(*keys)
    if keys.first.is_a?(Regexp)
      reject { |k,v| k =~ keys.first }
    else
      reject { |k,v| keys.include? k }
    end
  end

  # >> { :a => 1, :b => 2, :c => 3 }.pick(:a, :c)
  # => [ 1, 3 ]
  #
  def pick(*keys)
    return *keys.map { |k| self[k] } if keys.size > 1
    self[keys.first]
  end

  # Same return value as #pick but deletes the
  # the keys from the hash also.
  #
  def pluck(*keys)
    return *keys.map { |k| delete(k) } if keys.size > 1
    delete(keys.first)
  end

  # Access a key by calling a method with
  # the same name. Works for :name and "name".
  #
  # { :a => "b" }.a # => "b"
  # { "a" => :b }.a # => :b
  #
  # Asking for the boolean value of an key
  # will return true or false depending whether
  # the value is actually true, "true", 1 or "1".
  #
  # { :online => "1" }.online? # => true
  # { :online => "2" }.online? # => false
  #
  # Other method calls w/ arguments and/or block
  # will still work as expected.
  #
  def method_missing(name, *args, &block)
    super if args.size > 0 or block_given?

    if name.to_s =~ /\A(.+)\?\Z/
      key = $1
      val = indifferent_get(key)
      %w(true 1).include?(val.to_s)
    else
      indifferent_get(name)
    end
  end

  private

  def indifferent_get(name)
    self[name.to_s] || self[name.to_sym]
  end

end
