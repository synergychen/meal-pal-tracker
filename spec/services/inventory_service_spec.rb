require "rails_helper"

describe InventoryService do
  before :each do
    stub_request(:get, InventoryService::URL)
      .to_return(body: JSON.generate(stubbed_inventories))
  end

  context "#perform" do
    it "requests inventories api once" do
      service = InventoryService.new
      service.perform

      expect(WebMock).to have_requested(:get, InventoryService::URL).once
    end
  end

  context "#success?" do
    it "return true if inventories api succeeds" do
      service = InventoryService.new
      service.perform

      expect(service.success?).to be_truthy
    end
  end

  context "#save_all" do
    it "save all inventories to database" do
      service  = InventoryService.new
      service.perform
      service.save_all

      expect(Inventory.count).to eq stubbed_inventories.count
    end

    it "save as new inventory only when inventory amount changes" do
      FactoryGirl.create :inventory,
        id: stubbed_inventories[0]["id"],
        amount: 0
      service = InventoryService.new
      service.perform
      service.save_all

      expect(Inventory.count).to eq stubbed_inventories.count + 1
    end
  end

  def stubbed_inventories
    [
      {
        "i
d": "2380c97b-8d1f-4e98-a48d-ad4bd886c021",
        "date": "20171003",
        "amount": 199,
        "mpn_amount": 0
      },
      {
        "id": "f1c9f47a-764a-4668-a72b-ab84c92b494d",
        "date": "20171003",
        "amount": 100,
        "mpn_amount": 0
      }
    ]
  end
end
