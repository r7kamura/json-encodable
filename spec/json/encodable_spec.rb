require "spec_helper"

describe JSON::Encodable do
  subject do
    instance.to_json(options)
  end

  let(:klass) do
    Class.new do
      include JSON::Encodable

      property :id
      property :title
      property :username

      # Dummy name to prevent defining a class in the global namespace
      def self.name
        "Foo::BarBaz"
      end

      def id
        1
      end

      def title
        "wonderland"
      end

      def username
        "alice"
      end
    end
  end

  let(:options) do
    {}
  end

  let(:instance) do
    klass.new
  end

  describe "#to_json" do
    context "without any options" do
      it "returns an Object in JSON format" do
        should be_json_as(
          id: 1,
          title: "wonderland",
          username: "alice",
        )
      end
    end

    context "with :except option in Array" do
      before do
        options[:except] = [:id]
      end

      it "excludes those properties" do
        should be_json_as(
          title: "wonderland",
          username: "alice",
        )
      end
    end

    context "with :except option in non-Array" do
      before do
        options[:except] = :id
      end

      it "is treated as an Array" do
        should be_json_as(
          title: "wonderland",
          username: "alice",
        )
      end
    end

    context "with :only option in Array" do
      before do
        options[:only] = [:id]
      end

      it "excludes those properties" do
        should be_json_as(id: 1)
      end
    end

    context "with :only option in non-Array" do
      before do
        options[:only] = :id
      end

      it "is treated as an Array" do
        should be_json_as(id: 1)
      end
    end
  end
end
