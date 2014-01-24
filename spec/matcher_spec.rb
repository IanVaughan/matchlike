require 'spec_helper'
require './lib/matcher'

describe Matcher do
  let(:instance) { Matcher.new(user) }

  let(:user)  { User.new('1', ['1','2','3','4','5']) }
  let(:user2) { User.new('2', ['1']) }
  let(:user3) { User.new('3', ['6']) }
  let(:user4) { User.new('4', ['1','2']) }
  let(:user5) { User.new('5', ['1','3','5','6']) }
  let(:user6) { User.new('6', ['7']) }

  describe '#match' do
    specify { expect(instance.match(user2)).to eq ['1'] }
    specify { expect(instance.match(user3)).to eq [] }
    specify { expect(instance.match(user4)).to eq ['1', '2'] }
    specify { expect(instance.match(user5)).to eq ['1', '3', '5'] }
  end

  describe '#sort' do
    subject { instance.sort(users) }

    let(:users) { [user, user2, user3, user4, user5, user6] }
    let(:result) { [user, user5, user4, user2] }

    it 'returns a ordered list of highest matched users first' do
      expect(subject).to eq result
    end
  end

  describe '#show' do
    subject { instance.show(users) }

    let(:users) { [user, user2, user3, user4, user5, user6] }
  end
end
