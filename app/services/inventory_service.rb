class InventoryService
  URL = "https://secure.mealpal.com/api/v1/cities/00000000-1000-4000-9845-9344bdb9408c/product_offerings/lunch/menu_inventories"

  def initialize
    @request = set_request
  end

  def perform
    @response = @request.run
  end

  def success?
    @response.success?
  end

  def save_all
    inventories.each do |inventory_json|
      unless has_same_amount(inventory_json)
        save(inventory_json)
      end
    end
  end

  private

  def inventories
    JSON.parse @response.body
  end

  def save(json)
    inventory = Inventory.new(
      schedule_id: json["id"],
      serve_date: json["date"],
      amount: json["amount"],
      mpn_amount: json["mpn_amount"]
    )

    unless inventory.save
      Rails.logger.info "Failed to save inventory: #{json}"
    end
  end

  def has_same_amount(json)
    record = Inventory.find_by(schedule_id: json["id"])

    record && (record.amount == json["amount"])
  end

  def set_request
    Typhoeus::Request.new(
      URL,
      method: :get,
      cookiefile: "./tmp/cookies"
    )
  end
end
