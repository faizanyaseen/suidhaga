module OwnerAuthorization
  extend ActiveSupport::Concern

  included do
    before_action :ensure_owner
  end

  private

  def ensure_owner
    unless current_user&.owner?
      redirect_to root_path, alert: t('errors.not_authorized')
    end
  end
end 