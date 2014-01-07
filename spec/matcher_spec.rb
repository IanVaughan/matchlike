require 'spec_helper'
require './lib/matcher'

describe Matcher do
  let(:user) {
    [{:user_id=>"1", :id=>"1"},
     {:user_id=>"1", :id=>"2"},
     {:user_id=>"1", :id=>"3"},
     {:user_id=>"1", :id=>"4"},
     {:user_id=>"1", :id=>"5"}]
  }

  let(:user2) {
    [{:user_id=>"2", :id=>"1"}]
  }
  let(:user3) {
    [{:user_id=>"3", :id=>"6"}]
  }
  let(:user4) {
    [{:user_id=>"4", :id=>"1"},
     {:user_id=>"4", :id=>"2"}]
  }
  let(:user5) {
    [{:user_id=>"4", :id=>"1"},
     {:user_id=>"4", :id=>"3"},
     {:user_id=>"4", :id=>"6"}]
  }

  subject { Matcher.new }

  describe '#match' do
    specify { expect(subject.match(user, user2)).to eq ['1'] }
    specify { expect(subject.match(user, user3)).to eq [] }
    specify { expect(subject.match(user, user4)).to eq ['1', '2'] }
    specify { expect(subject.match(user, user5)).to eq ['1', '3'] }
  end

  describe '#sort' do
    let(:users) { [user, user2, user3, user4, user5] }

    it 'returns a ordered list of highest matched users first' do
      result = [
        [{:user_id=>"4", :id=>"1"},
         {:user_id=>"4", :id=>"3"},
         {:user_id=>"4", :id=>"6"}],
        [{:user_id=>"3", :id=>"6"}]]
      expect(subject.sort(users)).to eq result
    end
  end

  describe '#show' do
    let(:users) { [user, user2, user3, user4, user5] }

    it 'returns a hash of user ids and matchs' do
      result = {'4' => ['1', '3', '6'], '3' => ['6']}
      expect(subject.show(users)).to eq result
    end
  end
end
