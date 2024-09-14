#!/usr/bin/env ruby

require 'csv'
require 'rubyXL'
RubyXL.class_variable_set(:@@suppress_warnings, true)

configs = {
  '植物（基础）' => {
    name: 'plants-base.csv',
    header: %w[group key npl adj ssg spl rtn tkn hbn lbn tgn cpn name name_translation],
  },
  '植物（特殊）' => {
    name: 'plants-special.csv',
    header: %w[group key field word word_translation],
  },
  '植物（规则）' => {
    name: 'plants-rules.csv',
    header: %w[rule source target match_word build_word match_translation build_translation],
  },
  '帮助文档' => {
    name: 'help-documents.csv',
    header: %w[help_id help_name section_id title title_translation document document_translation],
  },
  '帮助文本' => {
    name: 'help-texts.csv',
    header: %w[help_id help_name type text text_translation],
  },
  '物品' => {
    name: 'items.csv',
    header: %w[filename key noun_single noun_plural noun_translation adjective adjective_translation],
  },
  '内置物品' => {
    name: 'items-builtin.csv',
    header: %w[id type wildcard wildcard_translation use_noun_for_adj use_standard_plural],
  },
  '物质名词' => {
    name: 'materials-nouns.csv',
    header: %w[rules noun noun_translation],
  },
  '物质形容词' => {
    name: 'materials-adjectives.csv',
    header: %w[source_noun adjective adjective_translation_override],
  },
  '物质生成规则' => {
    name: 'materials-generation-rules.csv',
    header: %w[rule state prefix suffix template],
  },
  '材料模板' => {
    name: 'materials_templates.csv',
    header: %w[filename key noun_all_solid noun_all_solid_translation noun_solid noun_solid_translation noun_powder noun_powder_translation noun_liquid noun_liquid_translation noun_gas noun_gas_translation adjective_all_solid adjective_all_solid_translation adjective_solid adjective_solid_translation adjective_powder adjective_powder_translation adjective_liquid adjective_liquid_translation adjective_gas adjective_gas_translation],
  },
  '经验' => {
    name: 'skill_levels.csv',
    header: %w[id adjective adjective_translation],
  },
  '技能' => {
    name: 'skill_names.csv',
    header: %w[id noun noun_translation noun_dwarf_single noun_dwarf_plural noun_dwarf_translation],
  },
}

TARGET_DIR = 'translations'
FileUtils.rm_rf(TARGET_DIR)
FileUtils.mkdir_p(TARGET_DIR)

workbook = RubyXL::Parser.parse(ARGV.first)
configs.each do |key, config|
  worksheet = workbook[key]
  name, header = config.values_at(:name, :header)

  csv = header.to_csv(row_sep: "\r\n")

  i = 0
  loop do
    i += 1
    row = worksheet[i]
    break if row.nil?

    csv_row = header.count.times.map { |j| row[j]&.value }
    csv += csv_row.to_csv(row_sep: "\r\n") unless csv_row.all?(&:nil?)
  end

  File.write(File.join(TARGET_DIR, name), csv)
end
