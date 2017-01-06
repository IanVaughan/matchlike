require 'spec_helper'
require './lib/user'

describe User do
  # let(:instance) { User.new }

  context 'adding and getting records' do
    let(:user) { User.new('1', '2', '3', '4') }

    it { expect(user).to eq [] }
  end
end
