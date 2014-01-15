require 'spec_helper'
require './lib/database'

describe Database do
  subject { Database.new }
  before { delete_all_data }

  context 'adding records' do
    before { subject.add('1', '2', '3', '4') }
    let(:user_data) { {:user_id=>"1", :like_id=>"2", :category=>"3", :name=>"4"} }
    specify { expect(subject.get('1')).to eq [user_data] }
  end

  context 'deleting records' do
    before { subject.add('1', '2', '3', '4') }
    before { subject.add('5', '6', '7', '8') }
    before { subject.delete_all_for('1') }
    let(:user_data) { {:user_id=>"5", :like_id=>"6", :category=>"7", :name=>"8"} }
    specify { expect(subject.get_all_users).to eq ['5'] }
    specify { expect(subject.get('1')).to eq [] }
    specify { expect(subject.get('5')).to eq [user_data] }
  end

  def delete_all_data
    users = subject.get_all_users
    users.each { |u| subject.delete_all_for(u) }
  end
end
