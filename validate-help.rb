#!/usr/bin/env ruby

require 'csv'

TARGET_DIR = 'translations'
CSV.parse(File.read(File.join(TARGET_DIR, 'help-documents.csv'))).each.with_index do |row, i|
  next if i == 0

  left = row[-2].scan(/\[[^\]]+\]/).sort
  right = row[-1].scan(/\[[^\]]+\]/).sort
  left = left.group_by(&:itself).transform_values(&:count)
  right = right.group_by(&:itself).transform_values(&:count)
  # next if left == right

  lb = left.delete('[B]')
  rb = right.delete('[B]')

  left.reject! { |k, v| k =~ /\A\[KEY:\d+\]\z/ }
  right.reject! { |k, v| k =~ /\A\[KEY:\d+\]\z/ }

  lr = left.delete('[C:7:0:0]') || 0
  rr = right.delete('[C:7:0:0]') || 0

  ll = left.values.sum || 0
  rl = right.values.sum || 0

  next if lb == rb && ll == lr && rl == rr
  pp lb == rb, ll == lr, rl == rr
  pp ll, lr, rl, rr

  puts row.to_csv, left, right
  puts
end
