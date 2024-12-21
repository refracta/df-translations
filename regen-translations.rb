#!/usr/bin/env ruby

require 'csv'
require 'rubyXL'
RubyXL.class_variable_set(:@@suppress_warnings, true)

configs = {
  '帮助文档' => {
    name: 'help-documents.csv',
    header: %w[help_id help_name section_id title title_translation document document_translation],
  },
  '帮助文本' => {
    name: 'help-texts.csv',
    header: %w[help_id help_name type text text_translation],
  },
  '界面' => {
    name: 'interfaces.csv',
    header: %w[viewscreen context alignment text text_translation],
  },
  '月份' => {
    name: 'months.csv',
    header: %w[id text text_translation],
  },
  '季节' => {
    name: 'seasons.csv',
    header: %w[id text text_translation],
  },
}

TARGET_DIR = 'translations'
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
