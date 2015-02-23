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

  describe ".to_json" do
    context "without any options" do
      it "returns an Object in JSON format" do
        should be_json_as(
          id: 1,
          title: "wonderland",
          username: "alice",
        )
      end
    end

    [:id, [:id]].each do |except_value|
      context "when a #{except_value.class.name.downcase} is given as :except option" do
        before do
          options[:except] = except_value
        end

        it "excludes those properties" do
          instance.should_not_receive(:id)
          should be_json_as(
            title: "wonderland",
            username: "alice",
          )
        end
      end
    end

    [:id, [:id]].each do |only_value|
      context "when a #{only_value.class.name.downcase} is given as :only option" do
        before do
          options[:only] = only_value
        end

        it "excludes those properties" do
          should be_json_as(id: 1)
        end
      end
    end
  end
end
