module Marshal
  class << self
    def dump_with_mocks(*args)
      object = args.shift
      spies = Spy.get_spies(object)
      if spies.empty?
        return dump_without_mocks(*args.unshift(object))
      end

      spy_hook_options = spies.map do |spy|
        opts = spy.opts
        [spy.unhook, opts]
      end

      begin
        dump_without_mocks(*args.unshift(object.dup))
      ensure
        spy_hook_options.each do |spy, opts|
          spy.hook(opts)
        end
      end
    end

    alias_method :dump_without_mocks, :dump
    undef_method :dump
    alias_method :dump, :dump_with_mocks
  end
end
