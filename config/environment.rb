# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

#amazon:EcsのAPIキーをsercrets.ymlから取得する関数
Amazon::Ecs.options = {
    associate_tag:     Rails.application.secrets.associate_tag,
    AWS_access_key_id: Rails.application.secrets.aws_access_key_id,
    AWS_secret_key:   Rails.application.secrets.aws_secret_key
}

#RakutenWebServiceのAPIキーをsercrets.ymlから取得する関数
RakutenWebService.configuration do |c|
    # (Required) Appliction ID for your application.
    c.application_id = Rails.application.secrets.rakuten_application_id
    # (Optional) Affiliate ID for your Rakuten account.
    c.affiliate_id = Rails.application.secrets.rakuten_affiliate_id
end