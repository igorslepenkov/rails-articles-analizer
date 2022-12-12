module CouldCauseErrors
  extend ActiveSupport::Concern

  included do
    rescue_from NewslizerExceptions::DomainNotSupported, with: :domain_not_supported
    rescue_from NewslizerExceptions::SentimentAnalizerReturnedAnError, with: :unexpected_error_from_analizer
  end

  private

  def domain_not_supported
    flash[:alert] = 'Sorry, the link, that you provided could not be processed, because its source is not suported'
    redirect_to root_path and return
  end

  def unexpected_error_from_analizer
    flash[:alert] = 'Sorry, it seems that sentiment analizer responded with error, please try again later'
    redirect_to root_path and return
  end
end
