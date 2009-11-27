class MoveAttachmentsDirectoryToAssets < ActiveRecord::Migration
  def self.up
		FileUtils.cp_r(Rails.root.join('public', 'attachments'), Rails.root.join('public', 'assets'), :verbose => true)
		FileUtils.rm_r(Rails.root.join('public', 'attachments'))
  end

  def self.down
		FileUtils.cp_r(Rails.root.join('public', 'assets'), Rails.root.join('public', 'attachments'), :verbose => true)
		FileUtils.rm_r(Rails.root.join('public', 'assets'))
  end
end
