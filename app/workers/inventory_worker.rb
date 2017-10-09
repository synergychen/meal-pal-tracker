class InventoryWorker
  include Sidekiq::Worker

  def perform
    inventory_service = InventoryService.new
    inventory_service.perform

    if inventory_service.success?
      Rails.logger.info("Finished Crawling inventories. Saving...")
      inventory_service.save_all
    else
      Rails.logger.info("Failed to crawl inventories.")
    end
  end
end
