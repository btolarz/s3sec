RSpec.describe "`s3sec check` command", type: :cli do
  it "executes `s3sec help check` command successfully" do
    output = `s3sec help check`
    expected_output = <<-OUT
Usage:
  s3sec check

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
