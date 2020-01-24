require_relative '../solution_05'
require 'rspec'

describe AlchemicalReduction do

  let(:polymer) {AlchemicalReduction.new('dabAcCaCBAcCcaDA')}

  it "reacts smaller units" do
    two_units = AlchemicalReduction.new('aA')
    expect(two_units.react).to eq('')
  end

end
