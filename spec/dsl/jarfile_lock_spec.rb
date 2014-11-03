require_relative '../spec_helper'
require 'maven/tools/dsl/jarfile_lock'

describe Maven::Tools::DSL::JarfileLock do

  let( :base ) { __FILE__.sub( /.rb$/, '/Jarfile' ) }

  subject { Maven::Tools::DSL::JarfileLock }

  it 'loads legacy Jarfile.lock' do
    lock = subject.new( base + '.legacy' )
    lock.coordinates( :test ).size.must_equal 0
    lock.coordinates.size.must_equal 52
  end

  it 'loads Jarfile.lock' do
    lock = subject.new( base )
    lock.coordinates( :test ).size.must_equal 7
    lock.coordinates.size.must_equal 45
  end

  it 'tests existence' do
    lock = subject.new( base )
    ( lock.coordinates( :test ) + lock.coordinates ).each do |c|
      lock.exists?( c ).must_equal true
      lock.exists?( c + ".bla" ).must_equal false
    end
  end

  it 'tests locked' do
    lock = subject.new( base )
    ( lock.coordinates( :test ) + lock.coordinates ).each do |c|
      lock.locked?( c ).must_equal true
      lock.locked?( c + ".bla" ).must_equal true
    end
  end

  it 'dumps data' do
    file = 'Jarfile.temp'
    file_lock = 'Jarfile.temp.lock'
    begin
      FileUtils.rm_f file_lock
      lock = subject.new( file )
      lock.update_unlocked( { :test => [ 'bla:blas:123' ],
                              :runtime => [ 'huffle:puffle:321' ] } )
      lock.dump
      lock = subject.new( file )
      lock.coordinates.must_equal ['huffle:puffle:321']
      lock.coordinates( :test ).must_equal ['bla:blas:123']    
    ensure
      FileUtils.rm_f file_lock
    end
  end

  it 'can replace the data' do
    lock = subject.new( 'something' )

    lock.replace( { :test => [ 'bla:blas:123' ],
                    :runtime => [ 'huffle:puffle:321' ] } )
    lock.coordinates.must_equal ['huffle:puffle:321']
    lock.coordinates( :test ).must_equal ['bla:blas:123'] 

    lock.replace( { :runtime => [ 'huffle:puffle:321' ] } )
    lock.coordinates.must_equal ['huffle:puffle:321']
    lock.coordinates( :test ).must_equal [] 

    lock.replace( { :test => [ 'bla:blas:123' ]} )
    lock.coordinates.must_equal []
    lock.coordinates( :test ).must_equal ['bla:blas:123'] 
  end

  it 'can add missing data idempotent' do
    lock = subject.new( 'something' )

    lock.update_unlocked( { :test => [ 'bla:blas:123' ],
                            :runtime => [ 'huffle:puffle:321' ] } ).must_equal true
    lock.update_unlocked( { :test => [ 'bla:blas:123' ],
                            :runtime => [ 'huffle:puffle:321' ] } ).must_equal true
    lock.coordinates.must_equal ['huffle:puffle:321']
    lock.coordinates( :test ).must_equal ['bla:blas:123'] 

    lock.update_unlocked( { :runtime => [ 'huffle:puffle:321' ] } ).must_equal true
    lock.coordinates.must_equal ['huffle:puffle:321']
    lock.coordinates( :test ).must_equal ['bla:blas:123'] 

    lock.update_unlocked( { :runtime => [ 'huffle:puffle2:321' ] } ).must_equal true
    lock.coordinates.must_equal ['huffle:puffle:321', 'huffle:puffle2:321']
    lock.coordinates( :test ).must_equal ['bla:blas:123'] 

    lock.update_unlocked( { :test => [ 'bla:blas:123' ]} ).must_equal true
    lock.coordinates.must_equal ['huffle:puffle:321', 'huffle:puffle2:321']
    lock.coordinates( :test ).must_equal ['bla:blas:123'] 

    lock.update_unlocked( { :test => [ 'bla:bla2:123' ]} ).must_equal true
    lock.coordinates.must_equal ['huffle:puffle:321', 'huffle:puffle2:321']
    lock.coordinates( :test ).must_equal ['bla:blas:123', 'bla:bla2:123'] 
  end

  it 'fails add data on version conflict' do
    lock = subject.new( 'something' )

    lock.replace( { :test => [ 'bla:blas:123' ],
                    :runtime => [ 'huffle:puffle:321' ] } )

    lock.update_unlocked( { :test => [ 'bla:blas:1233' ],
                            :runtime => [ 'huffle:puffle:3214' ] } ).must_equal false
    lock.coordinates.must_equal ['huffle:puffle:321']
    lock.coordinates( :test ).must_equal ['bla:blas:123'] 

    lock.update_unlocked( { :runtime => [ 'huffle:puffle:3214' ] } ).must_equal false
    lock.coordinates.must_equal ['huffle:puffle:321']
    lock.coordinates( :test ).must_equal ['bla:blas:123'] 

    lock.update_unlocked( { :test => [ 'bla:blas:1233' ]} ).must_equal false
    lock.coordinates.must_equal ['huffle:puffle:321']
    lock.coordinates( :test ).must_equal ['bla:blas:123'] 
  end
end
