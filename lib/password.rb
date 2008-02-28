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

require 'digest/sha2'

#
# This module contains functions for hashing and storing passwords.
# Copied from http://www.zacharyfox.com/blog/ruby-on-rails/password-hashing
# Written by Zachary Fox.
#
module Password

  # Generates a new salt and rehashes the password.
  def Password.update(password)
    salt = self.salt
    hash = self.hash(password,salt)
    self.store(hash, salt)
  end

  # Checks the password against the stored password.
  def Password.check(password, store)
    hash = self.get_hash(store)
    salt = self.get_salt(store)
    self.hash(password,salt) == hash
  end

  protected

  # Generates a psuedo-random 64 character string
  def Password.salt
    salt = ''
    64.times { salt << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }
    salt
  end

  # Generates a 128 character hash
  def Password.hash(password, salt)
    Digest::SHA512.hexdigest("#{password}:#{salt}")
  end

  # Mixes the hash and salt together for storage
  def Password.store(hash, salt)
    hash + salt
  end

  # Gets the hash from a stored password
  def Password.get_hash(store)
    store[0..127]
  end

  # Gets the salt from a stored password
  def Password.get_salt(store)
    store[128..192]
  end
end
