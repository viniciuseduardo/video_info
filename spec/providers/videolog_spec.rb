# encoding: utf-8
require 'spec_helper'

describe VideoInfo::Videolog do
  describe "info", :vcr do
    subject { VideoInfo::Videolog.new('http://www.videolog.tv/video.php?id=671092') }

    its(:provider)         { should == 'Videolog' }
    its(:video_id)         { should == '671092' }
    its(:url)              { should == 'http://videolog.tv/video.php?id=671092' }
    its(:embed_code)       { should =~ /<iframe width='560' height=315/ }
    its(:title)            { should == 'Novo Player Videolog' }
    its(:description)      { should =~ /Conheça o novo player do Videolog completamente customizável!/ }
    its(:keywords)         { should_not be_nil }
    its(:duration)         { should == "00:01:09" }
    its(:width)            { should be_nil }
    its(:height)           { should be_nil }
    its(:date)             { should == Time.parse("2011-06-27T05:19:19", Time.now.utc) }
    its(:thumbnail)        { should == 'http://videolog.tv/video_thumb.php?video=671092' }
    its(:view_count)       { should be >= 12832 }
  end

  describe "Video 946345", :vcr do
    subject { VideoInfo::Videolog.new('http://www.videolog.tv/video.php?id=946345') }

    its(:provider) { should == 'Videolog' }
    its(:duration) { should == "00:01:42" }
  end

  describe "Video 577494", :vcr do
    subject { VideoInfo::Videolog.new('http://www.videolog.tv/video.php?id=577494') }

    its(:view_count) { should be > 6000 }
  end

  context 'without http or www', :vcr do
    subject { VideoInfo::Videolog.new('videolog.tv/video.php?id=577494') }

    its(:provider) { should == 'Videolog' }
  end
  
  context 'url page user', :vcr do
    subject { VideoInfo::Videolog.new('http://www.videolog.tv/videolog/videos/526856') }

    its(:provider) { should == 'Videolog' }
    its(:video_id) { should == '526856' }
  end
end