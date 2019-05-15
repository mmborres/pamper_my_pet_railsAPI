require 'jwt'

class JsonWebToken
  # Encodes and signs JWT Payload with expiration
  def self.encode(payload)
    logger = ActiveSupport::Logger.new(STDOUT)

    payload.reverse_merge!(meta)
    
    logger.info "==========================encode"
    logger.info JWT
    logger.info payload
    #logger.info Rails.application.secrets.secret_key_base
    #logger.info ENV['SECRET_KEY_BASE']
    #logger.info ENV["SECRET_KEY_BASE"]
    
    #JWT.encode(payload, Rails.application.secrets.secret_key_base)
    #JWT.encode(payload, '4bb5645010e470053d20066aeacf6640ad9a0db1e0eb4663b5a59a3c55ea0a8e05902c10b492d08ff2821e414fb31d56671e182dbe8656e273bb645c4cd4843d')
    
    begin
      logger.info "Attempting ENV"
      JWT.encode(payload, ENV["SECRET_KEY_BASE"])
    rescue
      logger.info "re-Attempting with local ENV"
      JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end

  end

  # Decodes the JWT with the signed secret
  def self.decode(token)
    JWT.decode(token, Rails.application.secrets.secret_key_base)
  end

  # Validates the payload hash for expiration and meta claims
  def self.valid_payload(payload)
    if expired(payload) || payload['iss'] != meta[:iss] || payload['aud'] != meta[:aud]
      return false
    else
      return true
    end
  end

  # Default options to be encoded in the token
  def self.meta
    {
      exp: 7.days.from_now.to_i,
      iss: 'issuer_name',
      aud: 'client',
    }
  end

  # Validates if the token is expired by exp parameter
  def self.expired(payload)
    Time.at(payload['exp']) < Time.now
  end
end