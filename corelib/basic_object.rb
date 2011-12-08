class BasicObject
  def initialize(*args)
    nil
  end

  def ==(other)
    `self === other`
  end

  def __send__(symbol, *args, &block)
    `
      var meth = self[mid_to_jsid(symbol)];

      if (meth) {
        args.unshift(null);
        return meth.apply(self, args);
      }
      else {
        throw new Error("method missing yielder for " + symbol + " in __send__");
      }
    `
  end

  alias_method :send, :__send__

  alias_method :eql?, :==
  alias_method :equal?, :==

  def instance_eval(string = nil, &block)
    `
      if (block === nil) rb_raise(RubyArgError, 'block not supplied');
      return block.call(self, null);
    `
  end

  def instance_exec(*args, &block)
    `
      if (block === nil) rb_raise(RubyArgError, 'block not supplied');
      args.unshift(null);
      return block.apply(self, args);
    `
  end

  def method_missing(symbol, *args)
    raise NoMethodError, "undefined method `#{symbol}` for #{self.inspect}"
  end

  def singleton_method_added(symbol)
    nil
  end

  def singleton_method_removed(symbol)
    nil
  end

  def singleton_method_undefined(symbol)
    nil
  end
end
