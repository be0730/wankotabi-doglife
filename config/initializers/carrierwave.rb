# config/initializers/carrierwave.rb
CarrierWave.configure do |config|
  if Rails.env.production?
    cred_id = cred_secret = nil
    begin
      # ここで InvalidMessage が起きても rescue して先に進む
      cred_id     = Rails.application.credentials.dig(:aws, :access_key_id)
      cred_secret = Rails.application.credentials.dig(:aws, :secret_access_key)
    rescue => e
      Rails.logger.warn "[CarrierWave] credentials load failed at boot: #{e.class}: #{e.message}"
    end

    access_key = cred_id     || ENV["AWS_ACCESS_KEY_ID"]
    secret_key = cred_secret || ENV["AWS_SECRET_ACCESS_KEY"]
    region     = ENV.fetch("AWS_REGION", "ap-northeast-1")
    bucket     = ENV.fetch("AWS_BUCKET", "your-bucket-name-production")

    if access_key.blank? || secret_key.blank?
      # ビルド時に鍵が無くても落とさない（本番起動後にENV/credentialsがあればS3に戻せる）
      Rails.logger.error "[CarrierWave] AWS creds missing -> fallback to :file storage"
      config.storage = :file
    else
      config.fog_provider = "fog/aws"
      config.fog_credentials = {
        provider:              "AWS",
        aws_access_key_id:     access_key,
        aws_secret_access_key: secret_key,
        region:                region
      }
      config.fog_directory = bucket
      config.fog_public    = true
    end
  else
    config.storage = :file
  end
end
