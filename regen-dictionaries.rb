#!/usr/bin/env ruby

require 'csv'
require 'rubyXL'
RubyXL.class_variable_set(:@@suppress_warnings, true)

configs = {
  '生物' => {
    name: 'creatures.csv',
    header: %w[id table text translation],
  },
  '植物' => {
    name: 'plants.csv',
    header: %w[id table text translation],
  },
}

TARGET_DIR = 'dictionaries'
FileUtils.rm_rf(TARGET_DIR)
FileUtils.mkdir_p(TARGET_DIR)

workbook = RubyXL::Parser.parse(ARGV.first)
configs.each do |key, config|
  puts key
  worksheet = workbook[key]
  name, header = config.values_at(:name, :header)

  csv = header.to_csv(row_sep: "\r\n")

  i = 0
  loop do
    i += 1
    row = worksheet[i]
    break if row.nil?

    csv_row = header.count.times.map { |j| row[j]&.value }
    break if csv_row.all?(&:nil?)

    csv += csv_row.to_csv(row_sep: "\r\n")
  end

  File.write(File.join(TARGET_DIR, name), csv)
end
