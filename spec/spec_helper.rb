require 'dm-is-awesome_set'

require 'dm-core/spec/setup'
DataMapper::Spec.setup

require 'dm-migrations'
require 'dm-validations'

# classes/vars for tests
class Category
  include DataMapper::Resource

  property :id,       Serial
  property :name,     String
  property :scope,    Integer
  property :scope_2,  Integer

  is :awesome_set, :scope => [:scope, :scope_2]

  # convenience methods only for speccing.
  def pos; [lft,rgt] end
  def sco; {:scope => scope, :scope_2 => scope_2}; end
end

class Discrim1
  include DataMapper::Resource

  property :id,       Serial
  property :name,     String
  property :scope,    Integer
  property :scope_2,  Integer
  property :type,     Discriminator

  is :awesome_set, :scope => [:scope, :scope_2]

  # convenience methods only for speccing.
  def pos; [lft,rgt] end
  def sco; {:scope => scope, :scope_2 => scope_2}; end
end

class CatD11 < Discrim1
end

class CatD12 < Discrim1
end

class Discrim2
  include DataMapper::Resource

  property :id,       Serial
  property :name,     String
  property :scope,    Integer
  property :scope_2,  Integer
  property :type,     Discriminator

  is :awesome_set, :scope => [:scope, :scope_2, :type]

  # convenience methods only for speccing.
  def pos; [lft,rgt] end
  def sco; {:scope => scope, :scope_2 => scope_2}; end
end

class CatD21 < Discrim2
end

class CatD22 < Discrim2
end

class FileServer
  include DataMapper::Resource

  property :id,       Serial
  property :name,     String
end

class FileServerItem
  include DataMapper::Resource

  property :id,       Serial
  property :name,     String
  belongs_to :file_server
  is :awesome_set, :scope => [:file_server]
  # convenience methods only for speccing.
  def pos; [lft,rgt] end
  def sco; {:file_server => file_server}; end

end

# Quick hack for ruby 1.8.6 - really, it's a hack. Don't use this anywhere else.

class Hash
  def eql?(obj)
    if obj.is_a?(Hash)
      each { |k,v| return false unless self[k].eql?(obj[k]) }
      true
    else
      false
    end
  end
end

