require './console'

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
