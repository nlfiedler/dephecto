#--
# Copyright (C) 2007-2008  Nathan Fielder
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#++

require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users

  def test_invalid_with_empty_attributes
    user = User.new
    assert !user.valid?
    assert user.errors.invalid?(:username)
  end

  def test_unique_name
    user = User.new(:username => users('one').username,
      :password => 'foo', :email => 'neo@foo.com')
    assert !user.save
    assert_equal ActiveRecord::Errors.default_error_messages[:taken],
      user.errors.on(:username)
  end

  def test_authenticate
    user = User.new(:username => 'tomtom', :password => 'foobar',
      :email => 'tommy@example.com')
    assert user.save
    assert User.authenticate('tomtom', 'foobar')
    assert !User.authenticate('tomtom', 'fubar')
  end
end
