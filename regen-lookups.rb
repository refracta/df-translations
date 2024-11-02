#!/usr/bin/env ruby

require 'csv'
require 'rubyXL'
RubyXL.class_variable_set(:@@suppress_warnings, true)

configs = {
  '查询表-主表' => {
    name: 'index.csv',
    header: %w[table text translation],
  },
  '查询表-生物' => {
    name: 'creatures.csv',
    header: %w[table text translation],
  },
  '查询表-植物' => {
    name: 'plants.csv',
    header: %w[table text translation],
  },
  '查询表-技能' => {
    name: 'skills.csv',
    header: %w[table text translation],
  },
  '查询表-职业' => {
    name: 'professions.csv',
    header: %w[table text translation],
  },
  '查询表-职位' => {
    name: 'positions.csv',
    header: %w[table text translation],
  },
  '查询表-物质' => {
    name: 'materials.csv',
    header: %w[table text translation],
  },
  '查询表-图块' => {
    name: 'tiles.csv',
    header: %w[table text translation],
  },
  '查询表-信息标签' => {
    name: 'info-tags.csv',
    header: %w[table text translation],
  },
  '查询表-宝石' => {
    name: 'gems.csv',
    header: %w[table text translation],
  },
  '查询表-宝石细节' => {
    name: 'gems-details.csv',
    header: %w[table text translation],
  },
  '查询表-武器' => {
    name: 'weapons.csv',
    header: %w[table text translation],
  },
  '查询表-盔甲' => {
    name: 'armors.csv',
    header: %w[table text translation],
  },
  '查询表-足装' => {
    name: 'shoes.csv',
    header: %w[table text translation],
  },
  '查询表-盾牌' => {
    name: 'shields.csv',
    header: %w[table text translation],
  },
  '查询表-头装' => {
    name: 'helms.csv',
    header: %w[table text translation],
  },
  '查询表-手装' => {
    name: 'gloves.csv',
    header: %w[table text translation],
  },
  '查询表-弹药' => {
    name: 'ammos.csv',
    header: %w[table text translation],
  },
  '查询表-肉类' => {
    name: 'meats.csv',
    header: %w[table text translation],
  },
  '查询表-腿装' => {
    name: 'pants.csv',
    header: %w[table text translation],
  },
  '查询表-攻城弹药' => {
    name: 'siegeammos.csv',
    header: %w[table text translation],
  },
  '查询表-陷阱组件' => {
    name: 'trapcomps.csv',
    header: %w[table text translation],
  },
  '查询表-物品' => {
    name: 'items.csv',
    header: %w[table text translation],
  },
  '查询表-构筑菜单' => {
    name: 'construction-menus.csv',
    header: %w[table text translation],
  },
  '查询表-任务（临时）' => {
    name: 'tasks.csv',
    header: %w[table text translation],
  },
}

TARGET_DIR = 'lookups'
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
