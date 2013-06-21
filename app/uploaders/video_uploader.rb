# encoding: utf-8

class VideoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # https://gist.github.com/cblunt/1303386

  version :print do
    version :thumb    { process :resize_to_fit => [32, 32] }
    version :preview  { process :resize_to_fit => [256, 256] }
    version :full     { process :resize_to_fit => [2048, 2048] }
  end
 
  version :web do
    version :thumb    { process :resize_to_fit => [32, 32] }
    version :preview  { process :resize_to_fit => [128, 128] }
    version :full     { process :resize_to_fit => [1024, 768] }
  end

end
