require 'rspec'
require 'pry'
require Dir.pwd + '/backend/src/parser.rb'
RSpec.describe 'parsing' do
  def run(inp)
    Parser.new(inp).()
  end
  it {expect { run('a =') }.to_not raise_error(Racc::ParseError)}
  it {expect(run('a[b]')).to eq('a[b]')}
  it {expect(run('!a && b')).to eq('((! a) and b)')}
  it {expect(run('not a && b')).to eq('(! (a and b))')}
  it {expect(run('not a')).to eq('(! a)')}
  it {expect(run('!a')).to eq('(! a)')}
  it {expect(run('a * b / c')).to eq('((a * b) / c)')}
  it {expect(run('a = b || c')).to eq('(a = (b or c))')}
  it {expect(run('a = b or c')).to eq('((a = b) or c)')}
  it {expect(run('a = b and c')).to eq('((a = b) and c)')}
  it {expect(run('a = b && c')).to eq('(a = (b and c))')}
  it {expect(run('a = 1')).to eq('(a = 1)')}
  it {expect(run('1+1')).to eq('(1 + 1)')}

  it 'exists' do
    expect{Parser}.to_not raise_error
  end
  it '' do
    expect(run('1 + 1')).to eq('(1 + 1)')
  end
  it '' do
    expect(run('1 and 1')).to eq('(1 and 1)')
  end
  it '' do
    expect(run('var1 and var2')).to eq('(var1 and var2)')
  end
  it '' do
    expect(run('1 * 2 / 3')).to eq('((1 * 2) / 3)')
  end
end
