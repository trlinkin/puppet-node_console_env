begin
  # Try to require from the libdir
  require 'puppet/indirector/node/console'
rescue LoadError
  # Fallback to loading from internal modules
  require '/opt/puppet/share/puppet/modules/puppet_enterprise/lib/puppet/indirector/node/console'
end

class Puppet::Node::Node_console_env < Puppet::Node::Console

  def find(request)
    response = do_request do |connection, headers|
      connection.get("/nodes/#{request.key}", headers)
    end

    # Translate the output to ruby.
    result = translate(request.key, response)

    # Allow an 'environement' parameter to be used as the Puppet Environment.
    # In the event the Console has actually provided a value (the future?), back off.
    if result[:parameters]['environment']
      result[:environment] ||= result[:parameters]['environment']
    end

    # Set the requested environment if it wasn't overridden
    # If we don't do this it gets set to the local default
    result[:environment] ||= request.environment.name

    create_node(request.key, result)
  end
end
