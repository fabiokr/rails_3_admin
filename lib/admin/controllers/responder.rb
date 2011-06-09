module Admin
  module Controllers
    class Responder < ActionController::Responder
      include Responders::FlashResponder
      include Responders::CollectionResponder
    end
  end
end

Responders::FlashResponder.flash_keys = [:success, :alert]
