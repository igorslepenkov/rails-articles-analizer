module CouldCauseErrors
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :internal_server_error

    rescue_from NewslizerExceptions::DomainNotSupported, with: :domain_not_supported
  end

  private

  def domain_not_supported
    flash[:alert] = "Sorry, the link, that you provided could not be processed, because its source is not suported"
    redirect_to root_path and return
  end

  def internal_server_error
    flash[:alert] = 'Sorry, it seems an unexpected error came from server, please try again later'
    redirect_to root_path and return
  end
end
