# frozen_string_literal: true

class UserAvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model&.id}"
  end

  def extension_allowlist
    %w[jpg jpeg png]
  end

  def size_range
    (1.byte)..(50.megabytes)
  end

  def filename
    "#{secure_token}.#{file&.extension}"
  end

  version :thumb do
    process resize_to_fill: [50, 50]
  end

  version :halved do
    process :resize_to_half
  end

  protected

  def secure_token
    @secure_token ||= SecureRandom.uuid
  end

  private

  def resize_to_half
    manipulate! do |img|
      new_width = img[:width] / 2
      new_height = img[:height] / 2
      img.resize "#{new_width}x#{new_height}"
      img
    end
  end
end
