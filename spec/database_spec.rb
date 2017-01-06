require 'spec_helper'
require './lib/database'

describe Database do
  let(:instance) { Database.new }
  before { delete_all_data }

  context 'adding and getting records' do
    before { instance.add('user_1', 'like_1', 'category_1', 'name_1') }
    before { instance.add('user_1', 'like_2', 'category_2', 'name_2') }
    before { instance.add('user_2', 'like_3', 'category_3', 'name_3') }

    let(:result) { User.new('user_1', ['2', '6']) }

    it 'returns user data' do
      expect(instance.get('1')).to eq [result]
    end
  end

  context 'deleting records' do
    before { instance.add('1', '2', '3', '4') }
    before { instance.add('5', '6', '7', '8') }
    before { instance.delete_all_for('1') }

    let(:user_data) { {:user_id=>"5", :like_id=>"6", :category=>"7", :name=>"8"} }

    specify { expect(instance.get_all_user_ids).to eq ['5'] }
    specify { expect(instance.get('1')).to eq [] }
    specify { expect(instance.get('5')).to eq [user_data] }
  end

  describe '#get_all_users' do
    subject { instance.get_all_users }

    before { instance.add('1', '2', '3', '4') }
    before { instance.add('5', '6', '7', '8') }

    let(:user1) do
      {:user_id=>"1", :like_id=>"2", :category=>"3", :name=>"4"}
    end
    let(:user2) do
      {:user_id=>"5", :like_id=>"6", :category=>"7", :name=>"8"}
    end

    it { should eq [user1, user2] }
  end

  def delete_all_data
    users = instance.get_all_user_ids
    users.each { |u| instance.delete_all_for(u) }
  end
end
