require 's3sec/commands/config'

RSpec.describe S3sec::Commands::Config do
  it "executes `config` command successfully" do
    output = StringIO.new
    options = {}
    command = S3sec::Commands::Config.new(options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
