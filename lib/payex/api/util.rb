module PayEx::API::Util
  extend self

  def signed_hash(string)
    Digest::MD5.hexdigest(string + PayEx.encryption_key!)
  end

  def get_request_body(params, specs)
    parse_params(params, specs).tap do |params|
      params['hash'] = sign_params(params, specs)
    end
  end

  def sign_params(params, specs)
    signed_hash(hashed_params(params, specs).join)
  end

  def hashed_params(params, specs)
    specs.select { |key, options| options[:signed] }.
      keys.map { |key| params[key] }
  end

  def parse_params(params, specs)
    stringify_keys(params).tap do |result|
      _parse_params! result, specs
      result.select! { |k, v| v != nil }
    end
  end

  def stringify_keys(hash)
    Hash[*hash.map { |k, v| [k.to_s, v] }.flatten]
  end

  def _parse_params!(params, specs)
    for name, options in specs
      begin
        params[name] = parse_param(params[name], options)
      rescue PayEx::API::ParamError => error
        param_error! %{#{name.inspect}: #{error.message}}
      end
    end
  end

  def parse_param(param, options)
    unless options.is_a? Hash
      raise ArgumentError, %{expected Hash, got #{options.inspect}}
    end

    if param != nil
      result = param
    elsif options.include? :default
      result = options[:default]
      result = result.call if result.is_a? Proc
    else
      param_error! 'parameter required'
    end

    if options.include?(:format) and not options[:format] === result
      param_error! %{#{options[:format].inspect} required}
    else
      result
    end
  end

  def param_error! message
    raise PayEx::API::ParamError, message
  end
end