require 'test_helper'

class StatusTest < ActiveSupport::TestCase
	test 'that a status requires content' do 
		status = Status.new
		assert !status.save
		assert !status.errors[:content].empty?
	end

	test 'that status content is greater than two characters' do
		status = Status.new
		status.content = 'A'
		assert !status.save
		assert !status.errors[:content].empty?
	end

	test 'that a status must have a user_id' do
		status = Status.new
		status.content = 'hello'
		assert !status.save
		assert !status.errors[:user_id].empty?
	end

end
