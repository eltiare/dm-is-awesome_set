require File.dirname(__FILE__) + '/spec_helper'


scope = {:scope => 1, :scope_2 => 2}
scope2 = {:scope => 1, :scope_2 => 5}

describe DataMapper::Is::AwesomeSet do
  
  before(:all) do
    DataMapper.auto_migrate!
  end
  
  describe "without active DM Identity Map" do
  
    before :each do
      Category.auto_migrate!
      Discrim1.auto_migrate!
      Discrim2.auto_migrate!
    end

    it "puts itself as the last root in the defined scope on initial save" do

      c1 = Category.create(scope)
      c2 = Category.create(scope)
      c1.pos.should eql([1,2])
      c2.pos.should eql([3,4])

      c3 = Category.create(scope2)
      c4 = Category.create(scope2)
      c3.pos.should eql([1,2])
      c4.pos.should eql([3,4])

    end

    it "moves itself into a parent" do

      c1 = Category.create(scope)
      c2 = Category.create(scope)
      c3 = Category.create(scope)
      c2.move(:into => c1)

      [c1,c2,c3].each { |c| c.reload }
      c1.pos.should eql([1,4])
      c2.pos.should eql([2,3])
      c3.pos.should eql([5,6])


      c2.move(:into => c3)
      [c1,c2,c3].each { |c| c.reload }
      c1.pos.should eql([1,2])
      c3.pos.should eql([3,6])
      c2.pos.should eql([4,5])

      # This is to ensure that
      c4 = Category.new
      c4.move(:into => c1)
      [c1,c2,c3, c4].each { |c| c.reload }
      c4.sco.should eql(c1.sco)
      c1.pos.should eql([1,4])
      c4.pos.should eql([2,3])
      c3.pos.should eql([5,8])
      c2.pos.should eql([6,7])
    end

    it "moves around properly" do
      c1 = Category.create(scope)
      c2 = Category.create(scope)
      c3 = Category.create(scope)
      c4 = Category.new(scope)

      c2.move(:to => 1)
      [c1,c2,c3].each { |c| c.reload }
      c2.pos.should eql([1,2])
      c1.pos.should eql([3,4])
      c3.pos.should eql([5,6])

      c3.move(:higher)
      [c1,c2,c3].each { |c| c.reload }
      c2.pos.should eql([1,2])
      c3.pos.should eql([3,4])
      c1.pos.should eql([5,6])

      c3.move(:lower)
      [c1,c2,c3].each { |c| c.reload }
      c2.pos.should eql([1,2])
      c1.pos.should eql([3,4])
      c3.pos.should eql([5,6])

      c1.move(:lowest)
      [c1,c2,c3].each { |c| c.reload }
      c2.pos.should eql([1,2])
      c3.pos.should eql([3,4])
      c1.pos.should eql([5,6])

      c1.move(:highest)
      [c1,c2,c3].each { |c| c.reload }
      c1.pos.should eql([1,2])
      c2.pos.should eql([3,4])
      c3.pos.should eql([5,6])

      c4.move(:highest)
      [c1,c2,c3].each { |c| c.reload }

      c4.pos.should eql([1,2])
      c1.pos.should eql([3,4])
      c2.pos.should eql([5,6])
      c3.pos.should eql([7,8])

    end

    it "puts in proper places for above and below with scope" do
      c1 = Category.create(scope)
      c2 = Category.create(scope)
      c3 = Category.create(scope)

      c2.move(:into => c1)
      [c1,c2,c3].each { |c| c.reload }
      c1.pos.should eql([1,4])
      c2.pos.should eql([2,3])
      c3.pos.should eql([5,6])


      c3.move(:above => c2)
      [c1,c2,c3].each { |c| c.reload }
      c1.pos.should eql([1,6])
      c2.pos.should eql([4,5])
      c3.pos.should eql([2,3])

      c3.move(:below => c1)
      [c1,c2,c3].each { |c| c.reload }
      c1.pos.should eql([1,4])
      c2.pos.should eql([2,3])
      c3.pos.should eql([5,6])

      c2.move(:below => c1)
      [c1,c2,c3].each { |c| c.reload }
      c1.pos.should eql([1,2])
      c2.pos.should eql([3,4])
      c3.pos.should eql([5,6])
    end
  
    it "puts in proper places for above and below without scope" do
      c1 = Category.create
      c2 = Category.create
      c3 = Category.create

      c2.move(:into => c1)
      [c1,c2,c3].each { |c| c.reload }
      c1.pos.should eql([1,4])
      c2.pos.should eql([2,3])
      c3.pos.should eql([5,6])


      c3.move(:above => c2)
      [c1,c2,c3].each { |c| c.reload }
      c1.pos.should eql([1,6])
      c2.pos.should eql([4,5])
      c3.pos.should eql([2,3])

      c3.move(:below => c1)
      [c1,c2,c3].each { |c| c.reload }
      c1.pos.should eql([1,4])
      c2.pos.should eql([2,3])
      c3.pos.should eql([5,6])

      c2.move(:below => c1)
      [c1,c2,c3].each { |c| c.reload }
      c1.pos.should eql([1,2])
      c2.pos.should eql([3,4])
      c3.pos.should eql([5,6])
    end

    it "gets the parent" do
      c1 = Category.create(scope)
      c2 = Category.create(scope)
      c2.move(:into => c1)
      c2.parent.should_not be_nil
      c2.parent.id.should eql(c1.id)
    end

    it "identifies the root" do

      c1 = Category.create(scope)
      c2 = Category.create(scope)
      c3 = Category.create(scope)
      c2.move :into => c1
      c3.move :into => c2
      c3.root.should_not be_nil
      c3.root.id.should eql(c1.id)
    end

    it "gets all roots in the current scope" do
      c1 = Category.create(scope)
      c2 = Category.create(scope)
      c2.roots.size.should eql(2)

      c3 = Category.create(scope2)
      c4 = Category.create(scope2)
      c3.roots.size.should eql(2)
    end

    it "gets all ancestors" do
      c1 = Category.create(scope)
      c2 = Category.create(scope)
      c3 = Category.create(scope)

      c2.move(:into => c1)
      c3.move(:into => c2)
      c3.ancestors.size.should eql(2)
    end

    it "gets all siblings" do
      c1 = Category.create(scope)
      c2 = Category.create(scope)
      c3 = Category.create(scope)

      c2.move(:into => c1)
      c3.move(:into => c1)
      c3.siblings.size.should eql(1)
    end

    it "moves scope properly" do
      c1 = Category.create(scope)
      c2 = Category.create(scope)
      c3 = Category.create(scope)

      c4 = Category.create(scope2)
      c5 = Category.create(scope2)
      c6 = Category.create(scope2)

      c1.move(:into => c4)
      [c1,c2,c3,c4,c5,c6].each { |c| c.reload }

      c1.sco.should eql(scope2)

      c2.pos.should eql([1,2])
      c3.pos.should eql([3,4])

      c4.pos.should eql([1,4])
      c1.pos.should eql([2,3])
      c5.pos.should eql([5,6])
      c6.pos.should eql([7,8])

      c4.move(:into => c2)
      [c1,c2,c3,c4,c5,c6].each { |c| c.reload }
      c1.sco.should eql(scope)
      c4.sco.should eql(scope)

      c2.pos.should eql([1,6])
      c4.pos.should eql([2,5])
      c1.pos.should eql([3,4])
      c3.pos.should eql([7,8])


      c5.pos.should eql([1,2])
      c6.pos.should eql([3,4])

      # You can move into the root of a different scope by passing an object from that scope
      # or a hash that represents that scope
      c5.move(:root => scope)
      [c1,c2,c3,c4,c5,c6].each { |c| c.reload }
      c5.sco.should eql(scope)

      c2.pos.should eql([1,6])
      c4.pos.should eql([2,5])
      c1.pos.should eql([3,4])
      c3.pos.should eql([7,8])
      c5.pos.should eql([9,10])

      c6.pos.should eql([1,2])

    end
  
    it "should get all rows in the database if the discrimator is not part of scope" do
      c1 = CatD11.create(scope)
      c2 = CatD11.create(scope)
      c3 = CatD12.create(scope)
      c4 = CatD12.create(scope)
      CatD12.roots(scope).size.should eql(4)
    end
  
    it "should get only the same object types if discriminator is part of scope" do
      c1 = CatD21.create(scope)
      c2 = CatD21.create(scope)
      c3 = CatD22.create(scope2)
      c4 = CatD22.create(scope2)
      Discrim2.roots(scope.merge(:type => 'CatD21')).size.should eql(2)
      Discrim2.roots(scope2.merge(:type => 'CatD22')).size.should eql(2)
    end
    
  end
  
  describe "with active DM Identity Map" do
    
    it "puts itself as the last root in the defined scope on initial save when using the identity map" do
      repository do
        c1 = Category.create(scope)
        c2 = Category.create(scope)
        c1.pos.should eql([1,2])
        c2.pos.should eql([3,4])

        c3 = Category.create(scope2)
        c4 = Category.create(scope2)
        c3.pos.should eql([1,2])
        c4.pos.should eql([3,4])
      end
    end
    
    it "moves itself into a parent when using the identity map" do
      repository do
        c1 = Category.create(scope)
        c2 = Category.create(scope)
        c3 = Category.create(scope)
        c2.move(:into => c1)

        [c1,c2,c3].each { |c| c.reload }
        c1.pos.should eql([1,4])
        c2.pos.should eql([2,3])
        c3.pos.should eql([5,6])


        c2.move(:into => c3)
        [c1,c2,c3].each { |c| c.reload }
        c1.pos.should eql([1,2])
        c3.pos.should eql([3,6])
        c2.pos.should eql([4,5])

        # This is to ensure that
        c4 = Category.new
        c4.move(:into => c1)
        [c1,c2,c3, c4].each { |c| c.reload }
        c4.sco.should eql(c1.sco)
        c1.pos.should eql([1,4])
        c4.pos.should eql([2,3])
        c3.pos.should eql([5,8])
        c2.pos.should eql([6,7])
      end
    end
    
    it "moves around properly when using the identity map" do
      repository do
        c1 = Category.create(scope)
        c2 = Category.create(scope)
        c3 = Category.create(scope)
        c4 = Category.new(scope)

        c2.move(:to => 1)
        [c1,c2,c3].each { |c| c.reload }
        c2.pos.should eql([1,2])
        c1.pos.should eql([3,4])
        c3.pos.should eql([5,6])

        c3.move(:higher)
        [c1,c2,c3].each { |c| c.reload }
        c2.pos.should eql([1,2])
        c3.pos.should eql([3,4])
        c1.pos.should eql([5,6])

        c3.move(:lower)
        [c1,c2,c3].each { |c| c.reload }
        c2.pos.should eql([1,2])
        c1.pos.should eql([3,4])
        c3.pos.should eql([5,6])

        c1.move(:lowest)
        [c1,c2,c3].each { |c| c.reload }
        c2.pos.should eql([1,2])
        c3.pos.should eql([3,4])
        c1.pos.should eql([5,6])

        c1.move(:highest)
        [c1,c2,c3].each { |c| c.reload }
        c1.pos.should eql([1,2])
        c2.pos.should eql([3,4])
        c3.pos.should eql([5,6])

        c4.move(:highest)
        [c1,c2,c3].each { |c| c.reload }

        c4.pos.should eql([1,2])
        c1.pos.should eql([3,4])
        c2.pos.should eql([5,6])
        c3.pos.should eql([7,8])
      end
    end
    
    it "puts in proper places for above and below with scope when using the identity map" do
      repository do
        c1 = Category.create(scope)
        c2 = Category.create(scope)
        c3 = Category.create(scope)

        c2.move(:into => c1)
        [c1,c2,c3].each { |c| c.reload }
        c1.pos.should eql([1,4])
        c2.pos.should eql([2,3])
        c3.pos.should eql([5,6])


        c3.move(:above => c2)
        [c1,c2,c3].each { |c| c.reload }
        c1.pos.should eql([1,6])
        c2.pos.should eql([4,5])
        c3.pos.should eql([2,3])

        c3.move(:below => c1)
        [c1,c2,c3].each { |c| c.reload }
        c1.pos.should eql([1,4])
        c2.pos.should eql([2,3])
        c3.pos.should eql([5,6])

        c2.move(:below => c1)
        [c1,c2,c3].each { |c| c.reload }
        c1.pos.should eql([1,2])
        c2.pos.should eql([3,4])
        c3.pos.should eql([5,6])
      end
    end
    
    it "puts in proper places for above and below without scope when using the identity map" do
      repository do
        c1 = Category.create
        c2 = Category.create
        c3 = Category.create

        c2.move(:into => c1)
        [c1,c2,c3].each { |c| c.reload }
        c1.pos.should eql([1,4])
        c2.pos.should eql([2,3])
        c3.pos.should eql([5,6])


        c3.move(:above => c2)
        [c1,c2,c3].each { |c| c.reload }
        c1.pos.should eql([1,6])
        c2.pos.should eql([4,5])
        c3.pos.should eql([2,3])

        c3.move(:below => c1)
        [c1,c2,c3].each { |c| c.reload }
        c1.pos.should eql([1,4])
        c2.pos.should eql([2,3])
        c3.pos.should eql([5,6])

        c2.move(:below => c1)
        [c1,c2,c3].each { |c| c.reload }
        c1.pos.should eql([1,2])
        c2.pos.should eql([3,4])
        c3.pos.should eql([5,6])
      end
    end
    
    it "gets the parent when using the identity map" do
      repository do
        c1 = Category.create(scope)
        c2 = Category.create(scope)
        c2.move(:into => c1)
        c2.parent.should_not be_nil
        c2.parent.id.should eql(c1.id)
      end
    end
    
    it "identifies the root when using the identity map" do
      repository do
        c1 = Category.create(scope)
        c2 = Category.create(scope)
        c3 = Category.create(scope)
        c2.move :into => c1
        c3.move :into => c2
        c3.root.should_not be_nil
        c3.root.id.should eql(c1.id)
      end
    end
    
    it "gets all roots in the current scope when using the identity map" do
      repository do
        c1 = Category.create(scope)
        c2 = Category.create(scope)
        c2.roots.size.should eql(2)

        c3 = Category.create(scope2)
        c4 = Category.create(scope2)
        c3.roots.size.should eql(2)
      end
    end
    
    it "gets all ancestors when using the identity map" do
      repository do
        c1 = Category.create(scope)
        c2 = Category.create(scope)
        c3 = Category.create(scope)

        c2.move(:into => c1)
        c3.move(:into => c2)
        c3.ancestors.size.should eql(2)
      end
    end
    
    it "gets all siblings when using the identity map" do
      repository do
        c1 = Category.create(scope)
        c2 = Category.create(scope)
        c3 = Category.create(scope)

        c2.move(:into => c1)
        c3.move(:into => c1)
        c3.siblings.size.should eql(1)
      end
    end
    
    it "moves scope properly when using the identity map" do
      repository do
        c1 = Category.create(scope)
        c2 = Category.create(scope)
        c3 = Category.create(scope)

        c4 = Category.create(scope2)
        c5 = Category.create(scope2)
        c6 = Category.create(scope2)

        c1.move(:into => c4)
        [c1,c2,c3,c4,c5,c6].each { |c| c.reload }

        c1.sco.should eql(scope2)

        c2.pos.should eql([1,2])
        c3.pos.should eql([3,4])

        c4.pos.should eql([1,4])
        c1.pos.should eql([2,3])
        c5.pos.should eql([5,6])
        c6.pos.should eql([7,8])

        c4.move(:into => c2)
        [c1,c2,c3,c4,c5,c6].each { |c| c.reload }
        c1.sco.should eql(scope)
        c4.sco.should eql(scope)

        c2.pos.should eql([1,6])
        c4.pos.should eql([2,5])
        c1.pos.should eql([3,4])
        c3.pos.should eql([7,8])


        c5.pos.should eql([1,2])
        c6.pos.should eql([3,4])

        # You can move into the root of a different scope by passing an object from that scope
        # or a hash that represents that scope
        c5.move(:root => scope)
        [c1,c2,c3,c4,c5,c6].each { |c| c.reload }
        c5.sco.should eql(scope)

        c2.pos.should eql([1,6])
        c4.pos.should eql([2,5])
        c1.pos.should eql([3,4])
        c3.pos.should eql([7,8])
        c5.pos.should eql([9,10])

        c6.pos.should eql([1,2])
      end
    end
    
    it "should get all rows in the database if the discrimator is not part of scope when using the identity map" do
      repository do
        c1 = CatD11.create(scope)
        c2 = CatD11.create(scope)
        c3 = CatD12.create(scope)
        c4 = CatD12.create(scope)
        CatD12.roots(scope).size.should eql(4)
      end
    end
    
    it "should get only the same object types if discriminator is part of scope when using the identity map" do
      repository do
        c1 = CatD21.create(scope)
        c2 = CatD21.create(scope)
        c3 = CatD22.create(scope2)
        c4 = CatD22.create(scope2)
        Discrim2.roots(scope.merge(:type => 'CatD21')).size.should eql(2)
        Discrim2.roots(scope2.merge(:type => 'CatD22')).size.should eql(2)
      end
    end
    
  end


end
