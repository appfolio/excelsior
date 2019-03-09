class EmailDomainValidator

  def self.allowed_email_domain?(email)
    allowed_email_domains.empty? || allowed_email_domains.any? { |domain| email =~ /@#{domain}\z/}
  end

  def self.allowed_email_domains
    (ENV['ALLOWED_EMAIL_DOMAINS'] || '').split(',')
  end

  def self.allowed_email_recipient?(email)
    !ENV['ALLOWED_EMAILS'].present? ||
      ENV['ALLOWED_EMAILS'].include?(email)
  end

end
