require "spec_helper"
require Rails.root.join("db/migrate/20100914223945_remove_reserved_from_automation.rb")

describe RemoveReservedFromAutomation do
  migration_context :up do
    let(:reserve_stub) { migration_stub(:Reserve)}
    let(:all_stubs)    { described_class::RESERVED_CLASSES.collect { |c| migration_stub(c) } }

    it "migrates reserved column" do
      expected = []
      all_stubs.each do |s|
        class_name = s.name.split("::").last
        reserved = {:class_name => class_name}.to_yaml

        rec = s.create!(:reserved => reserved)

        expected << {"resource_type" => class_name, "resource_id" => rec.id, "reserved" => reserved}
      end

      migrate

      actual = reserve_stub.all.collect { |r| r.attributes.slice("resource_type", "resource_id", "reserved") }
      actual.should have_same_elements expected
    end
  end
end
