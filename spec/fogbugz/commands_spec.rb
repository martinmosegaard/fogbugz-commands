require "spec_helper"

describe Fogbugz::Commands do
  it "has a version number" do
    expect(Fogbugz::Commands::VERSION).not_to be nil
  end
end
