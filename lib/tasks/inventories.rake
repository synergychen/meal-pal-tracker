namespace :inventories do
  desc "Crawl and save"
  task crawl: :environment do
    InventoryWorker.perform_async
  end

  desc "Intensive crawl"
  task intensive_crawl: :environment do
    ((0..59).step(5).to_a + (60..3600).step(60).to_a).each do |t|
      InventoryWorker.perform_in(t)
    end
  end
end
