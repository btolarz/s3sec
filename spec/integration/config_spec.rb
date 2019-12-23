RSpec.describe "`s3sec config` command", type: :cli do
  it "executes `s3sec help config` command successfully" do
    output = `s3sec help config`
    expected_output = <<-OUT
Usage:
  s3sec config

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
