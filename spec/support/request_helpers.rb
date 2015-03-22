module RequestHelpers 

  def json
    @json ||= JSON.parse(response.body)
  end

  %w(get post put patch delete).each do |method_name|
    define_method("auth_#{method_name}") do |user, uri, params = {}, env = {}, &block|
      __send__(method_name, uri, params, env.reverse_merge(Authorization: user.authentication_token), &block)
    end
  end

end
