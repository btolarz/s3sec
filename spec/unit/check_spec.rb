require 's3sec/commands/check'

RSpec.describe S3sec::Commands::Check do
  it "executes `check` command successfully" do
    output = StringIO.new
    options = {}
    command = S3sec::Commands::Check.new(options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
